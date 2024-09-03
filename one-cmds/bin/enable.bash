usage() {
  cat << EOF
Usage: one bin enable [-a|--all] <NAME>...
Desc:  Enable matched bin files
Arguments:
  <name>       bin name
Options:
  -a, --all    Enable all bin files
EOF
}

completion() {
  shopt -s nullglob
  local path

  for path in "${ONE_DIR}"/data/repos/*/bins/"${@: -1}"*; do
    basename "$path" .opt.bash
  done
}

create_symlink() {
  local name=$1
  local path=$2
  ln -fs "$path" "$ONE_DIR/enabled/bin/$name"
  printf "Enabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
}

set_exports() {
  if [[ ! -v EXPORTS ]]; then
    return
  fi

  local name=$1

  local file
  for file in "${EXPORTS[@]}"; do
    if [[ -f "$ONE_DIR/data/bins/${name}/$file" ]]; then
      chmod +x "$ONE_DIR/data/bins/${name}/$file"
    else
      print_err "Not found file \"$file\" to export"
    fi
  done
}

enable() {
  local path=$1
  local name=$2

  if [[ -x "$path" ]]; then
    create_symlink "$name" "$path"
  elif [[ $path == *.opt.bash ]]; then
    local t=bin ts=bins
    check_opt_mod_dep_cmds "$path"
    # Disable first, prevent duplicated module enabled with different priority
    disable_mod "$name" true
    download_mod_data "$name" "$path"

    local url bin_name

    # shellcheck disable=1090
    url=$(. "$path" && echo "${URL:-}")
    if [[ -n $url ]]; then
      chmod +x "$ONE_DIR/data/bins/$name/script.bash"

      # shellcheck disable=1090
      while read -r bin_name; do
        create_symlink "$bin_name" "$ONE_DIR/data/bins/$name/script.bash"
      done < <(. "$path" && echo "${EXPORTS[@]}")
    else
      (
        # shellcheck disable=1090
        . "$path"
        set_exports "$name"
        # shellcheck disable=1090
        while read -r bin_name; do
          create_symlink "$bin_name" "$ONE_DIR/data/bins/$name/$bin_name"
        done < <(. "$path" && echo "${EXPORTS[@]}")
      )
    fi
  else
    echo "The file is not executable: $path" >&2
    return "$ONE_EX_DATAERR"
  fi
}

main() {
  shopt -s nullglob
  local name path

  # shellcheck source=../../one-cmds/mod.bash
  . "$ONE_DIR/one-cmds/mod.bash"
  # shellcheck source=../../deps/lobash.bash
  . "$ONE_DIR/deps/lobash.bash"

  if [[ ${1:-} == -a ]] || [[ ${1:-} == --all ]]; then
    for path in "${ONE_DIR}"/enabled/repos/*/bins/*; do
      name=$(basename "$path" .opt.bash)
      enable "$path" "$name" || true
    done
  else
    local repo_name paths

    for name in "$@"; do
      {
        paths=()

        for path in "${ONE_DIR}"/enabled/repos/*/bins/"$name"{,.opt.bash}; do
          paths+=("$path")
        done

        case ${#paths[@]} in
          1)
            enable "${paths[0]}" "$name"
            ;;

          0)
            print_err "No matched file '$name'"
            ;;

          *)
            print_err "Matched multi files for '$name':"
            printf '  %s\n' "${paths[@]}" >&2
            ;;
        esac
      } || true
    done
  fi
}
