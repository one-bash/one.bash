usage_enable() {
  cat <<EOF
Usage: one bin enable <NAME>...
Desc:  Enable matched bin files
Arguments:
  <name>  bin name
EOF
}

enable() {
  local path=$1
  local name=$2

  if [[ -x "$path" ]]; then
    ln -fs "$path" "$ONE_DIR/enabled/bin/$name"
    print_success "Enabled bin: $name"
  elif [[ $path == *.opt.bash ]]; then
    local t=bin  ts=bins
    check_opt_mod_dep_cmds "$path"
    # Disable first, prevent duplicated module enabled with different weight
    disable_mod "$name" true
    download_mod_data "$name" "$path"
    print_success "Enabled bin: $name"
  else
    echo "No found bin file '$name'." >&2
  fi
}

enable_bin() {
  local name path

  . "$ONE_DIR/bash/mod.bash"

  if [[ ${1:-} == --all ]]; then
    local paths=()
    for path in "${ONE_DIR}"/enabled/repos/*/bins/*; do
      name=$(basename "$path" .opt.bash)
      enable "$path" "$name"
    done
  else
    local repo_name

    for name in "$@"; do
      for path in "${ONE_DIR}/enabled/repos/$repo_name/bins/$name"{,.opt.bash}; do
        paths+=(path)
      done

      case ${#paths[@]} in
        1)
          enable "${paths[0]}" "$name"
          ;;

        0)
          print_error "No such bin '$name' in repo '$repo_name'"
          ;;

        *)
          print_error 'The bin '%name' matched multi repos.'
          printf '%s\n' "${paths[@]}"
          ;;
      esac
    done
  fi
}
