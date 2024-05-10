usage_run() {
  cat <<EOF
Usage: one sub run [-h] <cmd>
Description:  Run sub command
Options:
  -h          Print the usage of sub command
EOF
}

_one_is_completable() {
  grep -i '^# one.bash:completion' "$1" >/dev/null
}

complete_run() {
  local path

  if (( $# < 2 )) || [[ $1 == -h ]]; then
    for path in "$ONE_DIR"/enabled/sub/* ; do
      if [[ -x $path ]]; then basename "$path"; fi
    done
  else
    path="$ONE_DIR"/enabled/sub/$1

    if [[ -f $path ]] && _one_is_completable "$path"; then
      shift 1
      # shellcheck disable=2097,2098
      COMP_CWORD=$(( COMP_CWORD - 2 )) "$path" --complete "$@"
    fi
  fi
}

run_sub() {
  if (( $# == 0 )); then
    usage_run
    return 0
  fi

  local name=$1
  shift 1

  if [[ $name == -h ]]; then
    one sub help "$@"
  else
    "$ONE_DIR/enabled/sub/$name" "$@"
  fi
}
