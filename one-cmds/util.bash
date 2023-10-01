get_action() {
  local action=$1

  if [[ -n ${alias_map[$action]:-} ]]; then
    echo "${alias_map[$action]}"
  elif [[ ! -f "$ONE_DIR/one-cmds/$cmd/$action.bash" ]]; then
    echo "Invalid action '$action'" >&2
    return 8
  else
    echo "$action"
  fi
}

_show_usage() {
  # shellcheck disable=1090
  . "$ONE_DIR/one-cmds/$cmd/usage.bash"
  usage
}

parse_help() {
  if (( $# == 0 )); then
    _show_usage
    exit 0
  elif [[ $1 == -h ]] || [[ $1 == --help ]]; then
    if (( $# > 1 )); then
      # shellcheck disable=1090
      . "$ONE_DIR/one-cmds/$cmd/$action.bash"
      usage_"$(get_action "$2")"
    else
      _show_usage
    fi
    exit 0
  elif [[ ${*: -1} == --help ]] ; then
    if (( $# > 1 )); then
      # shellcheck disable=1090
      . "$ONE_DIR/one-cmds/$cmd/$action.bash"
      usage_"$(get_action "$1")";
    else
      _show_usage
    fi
    exit 0
  fi
}

ensure_ONE_DIR() {
  if [[ -z ${ONE_DIR:-} ]]; then
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
    readonly SCRIPT_DIR
    export ONE_DIR=$SCRIPT_DIR/..
  fi
}

# @param cmd
# @param actions
# @param $@
parse_completion() {
  if [[ "${3:-}" != --complete ]]; then return; fi

  local cmd=$1
  local -n _actions=$2
  shift 2

  if (( COMP_CWORD < 3 )); then
    words=("${_actions[@]}" -h --help)
    printf '%s\n' "${words[@]}"
  elif [[ $2 == -h ]] || [[ $2 == --help ]]; then
    printf '%s\n' "${_actions[@]}"
  else
    local action=$2
    if [[ -f $ONE_DIR/one-cmds/$cmd/$action.bash ]]; then
      # shellcheck disable=1090
      . "$ONE_DIR/one-cmds/$cmd/$action.bash"

      shift 2
      if type -t "complete_$action" &> /dev/null; then
        "complete_$action" "$@"
      fi
    fi
  fi

  exit 0
}

parse_cmd() {
  local cmd=$1
  shift

  parse_help "$@"

  action=$(get_action "$1")
  shift

  # shellcheck source=../deps/colors.bash
  . "$ONE_DIR/deps/colors.bash"

# shellcheck source=../bash/load-config.bash
  . "$ONE_DIR/bash/load-config.bash"

# shellcheck disable=1090
  . "$ONE_DIR/one-cmds/$cmd/$action.bash"
  "${action}_${cmd}" "$@"
}

print_error() {
  printf "%b%s%b\n" "$RED" "$1" "$RESET_ALL" >&2
}

print_success() {
  printf "%b%s%b\n" "$GREEN" "$1" "$RESET_ALL"
}

print_verb() {
  printf "%b[Verbose] %s%b\n" "$GREY" "$1" "$RESET_ALL"
}
