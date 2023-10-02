usage_enable() {
  cat <<EOF
Usage: one bin enable <NAME>...
Desc:  Enable matched bin files
Arguments:
  <name>  bin name
EOF
}

complete_enable() {
  shopt -s nullglob
  local path

  for path in "${ONE_DIR}"/data/repos/*/bins/"${@: -1}"*; do
    basename "$path" .opt.bash
  done
}

enable() {
  local path=$1
  local name=$2

  if [[ -x "$path" ]]; then
    ln -fs "$path" "$ONE_DIR/enabled/bin/$name"
    printf "Enabled bin: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
  elif [[ $path == *.opt.bash ]]; then
    local t=bin  ts=bins
    check_opt_mod_dep_cmds "$path"
    # Disable first, prevent duplicated module enabled with different weight
    disable_mod "$name" true
    download_mod_data "$name" "$path"
    printf "Enabled bin: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
  else
    echo "No found bin file '$name'." >&2
    return 3
  fi
}

enable_bin() {
  shopt -s nullglob
  local name path

  . "$ONE_DIR/bash/mod.bash"

  if [[ ${1:-} == --all ]]; then
    for path in "${ONE_DIR}"/enabled/repos/*/bins/*; do
      name=$(basename "$path" .opt.bash)
      enable "$path" "$name" || true
    done
  else
    local repo_name paths

    for name in "$@"; do
      {
        paths=()

        for path in "${ONE_DIR}/enabled/repos/"*"/bins/$name"{,.opt.bash}; do
          paths+=("$path")
        done

        case ${#paths[@]} in
          1)
            enable "${paths[0]}" "$name"
            ;;

          0)
            print_error "No matched bin '$name'"
            ;;

          *)
            print_error "Matched multi bins for '$name':"
            printf '  %s\n' "${paths[@]}" >&2
            ;;
        esac
      } || true
    done
  fi
}
