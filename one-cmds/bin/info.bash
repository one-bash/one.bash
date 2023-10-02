usage_info() {
  cat <<EOF
Usage: one bin info <NAME>
Desc:  Show the information of matched bin files
Arguments:
  <name>  bin name
EOF
}

complete_info() {
  shopt -s nullglob
  local path

  for path in "${ONE_DIR}"/data/repos/*/bins/"${@: -1}"*; do
    basename "$path" .opt.bash
  done
}

info_bin() {
  local name=${1:-} path

  if [[ -z $name ]]; then
    usage_info
    return 0
  fi

  # shellcheck disable=2034
  PRINT_INFO_KEY_WIDTH=-5

  shopt -s nullglob
  for path in "$ONE_DIR"/data/repos/*/bins/"$name"; do
    if [[ $path =~ \/data\/repos\/([^\/]+)\/ ]]; then
      print_info_item Repo "${BASH_REMATCH[1]}"
    fi

    print_info_item Path "$path"
  done
}
