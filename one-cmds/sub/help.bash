usage_help() {
  cat <<EOF
Usage: one sub help <cmd>
Desc:  Print the usage of ONE_SUB command
EOF
}

complete_help() {
  local path
  for path in "${ONE_DIR}"/data/repos/*/sub/"${@: -1}"*; do
    basename "$path" .opt.bash
  done
}

print_help() {
  local cmd=$1 file=$2 label arg

  if [[ -z ${file:-} ]]; then
    printf '%bNot found ONE_SUB command "%s".%b\n'  "$YELLOW" "$cmd" "$RESET_ALL" >&2
    return "$ONE_EX_USAGE"
  fi

  if [[ ! -x "${file}" ]]; then
    printf '%bNot found ONE_SUB command "%s". File is not executable or not existed: %s%b\n' "$YELLOW" "$cmd" "$file" "$RESET_ALL" >&2
    return "$ONE_EX_USAGE"
  fi

  label=$( grep -i '^# one.bash:usage' "$file" 2>/dev/null || true )

  if [[ -z "$label" ]]; then
    printf '%bThe command "%s" has not usage document.%b\n' "$YELLOW" "$cmd" "$RESET_ALL" >&2
    return "$ONE_EX_UNAVAILABLE"
  fi

  arg=$( sed -E 's/^# one.bash:usage(:?.*)/\1/i' <<<"$label" || true )

  if [[ -z ${arg#:} ]]; then
    arg='--help'
  else
    arg=${arg#:}
  fi

  "$file" "$arg"
}


help_sub() {
  if (( $# == 0 )); then
    usage_info
    return 0
  fi

  # shellcheck source=../../one-cmds/mod.bash
  . "$ONE_DIR/one-cmds/mod.bash"

  shopt -s nullglob

  local name path
  for name in "$@"; do
    for path in "${ONE_DIR}"/enabled/repos/*/sub/"$name"{,.bash,.sh}; do
      print_help "$name" "$path"
    done
  done
}
