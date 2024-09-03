_one_load() {
  local key before now path

  # Skip loading if skip_comps defined in runtime/bash_config.bash
  for key in "${ONE_SKIP_COMPS[@]}"; do
    if [[ bash/$key.bash == "$1" ]]; then
      one_debug "$YELLOW%s$RESET_ALL" "(skipped) To load \$ONE_DIR/$1"
      return 0
    fi
  done

  if [[ $1 =~ ^'/' ]]; then
    path=$1
    _path=$1
  else
    path="$ONE_DIR/$1"
    _path="\$ONE_DIR/$1"
  fi

  one_debug "To load $_path"
  before=$(_one_now)

  # shellcheck disable=SC1090

  # shellcheck disable=1090
  if ! . "$path"; then
    # shellcheck disable=2034
    ONE_LOADED=failed
  fi

  now=$(_one_now)
  local elapsed=$((now - before))

  if ((elapsed > ONE_DEBUG_SLOW_LOAD)); then
    one_debug "%bLoaded %s in %sms%b" "$YELLOW" "$_path" $elapsed "$RESET_ALL"
  else
    one_debug "%bLoaded %s in %sms%b" "$GREY" "$_path" $elapsed "$RESET_ALL"
  fi
}

_one_run() {
  one_debug "Todo: $*"
  before=$(_one_now)

  "$@"

  now=$(_one_now)
  local elapsed=$((now - before))

  if ((elapsed > ONE_DEBUG_SLOW_LOAD)); then
    one_debug '%bRun %s in %sms%b' "$YELLOW" "$cmd" $elapsed "$RESET_ALL"
  else
    one_debug '%bRun %s in %sms%b' "$GREY" "$cmd" $elapsed "$RESET_ALL"
  fi
}

_one_eval() {
  local cmd="eval \$($*)"
  one_debug "Todo: $cmd"
  before=$(_one_now)

  eval "$("$@")"

  now=$(_one_now)
  local elapsed=$((now - before))

  if ((elapsed > ONE_DEBUG_SLOW_LOAD)); then
    one_debug '%bRun %s in %sms%b' "$YELLOW" "$cmd" $elapsed "$RESET_ALL"
  else
    one_debug '%bRun %s in %sms%b' "$GREY" "$cmd" $elapsed "$RESET_ALL"
  fi
}
