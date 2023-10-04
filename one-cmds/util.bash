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
  local action
  if (( $# == 0 )); then
    _show_usage
    exit 0
  elif [[ $1 == -h ]] || [[ $1 == --help ]]; then
    if (( $# > 1 )); then
      action=$(get_action "$2")
      # shellcheck disable=1090
      . "$ONE_DIR/one-cmds/$cmd/$action.bash"
      "usage_$action"
    else
      _show_usage
    fi
    exit 0
  elif [[ ${*: -1} == --help ]] ; then
    if (( $# > 1 )); then
      action=$(get_action "$1")
      # shellcheck disable=1090
      . "$ONE_DIR/one-cmds/$cmd/$action.bash"
      "usage_$action";
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
    local action
    action="$(get_action "$2")"

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

  if [[ ! -f "$ONE_DIR/one-cmds/$cmd/$action.bash" ]]; then
    print_error "Invalid action: $action"
    return 2
  fi
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

print_info_item() {
  local key=$1
  local val=$2

  [[ -z $val ]] && return

  printf "%b%${PRINT_INFO_KEY_WIDTH:--10}s%b= " "$BLUE" "$key" "$RESET_ALL"

  case ${val,,} in
    true|enabled)
      printf '%b%s' "$GREEN" "$val"
      ;;
    false)
      printf '%b%s' "$RED" "$val"
      ;;
    disabled)
      printf '%b%s' "$GREY" "$val"
      ;;
    invalid)
      printf '%b%s' "$YELLOW" "$val"
      ;;
    *)
      printf '%s' "$val"
      ;;
  esac

  printf '%b\n' "$RESET_ALL"
}

metafor () {
  local keyword=$1;
  # Copy from composure.sh
  sed -n "/$keyword / s/['\";]*\$//;s/^[      ]*\(: _\)*$keyword ['\"]*\([^([].*\)*\$/\2/p"
}
