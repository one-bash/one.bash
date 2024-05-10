usage_info() {
  cat <<EOF
Usage: one sub info <cmd>
Desc:  Print the usage of ONE_SUB command
EOF
}

complete_info() {
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

print_info() {
  local name=$1 path
  for path in "${ONE_DIR}"/enabled/repos/*/sub/"$name"{,.bash,.sh}; do
    print_info_item Name "$name"
    print_info_item Repo "$(get_enabled_repo_name "$path")"
    print_info_item "Path" "$path"
  done
}

info_sub() {
  if (( $# == 0 )); then
    usage_info
    return 0
  fi

  # shellcheck source=../../bash/mod.bash
  . "$ONE_DIR/bash/mod.bash"

  shopt -s nullglob

  local name
  for name in "$@"; do
    print_info "$name"
  done
}
