_one_load() {
  local key before now

  # Skip loading if skip_comps defined in runtime/bash_config.bash
  for key in "${ONE_SKIP_COMPS[@]}"; do
    if [[ bash/$key.bash == "$1" ]]; then
      one_debug "$YELLOW%s$RESET_ALL" "(skipped) To load \$ONE_DIR/$1"
      return 0
    fi
  done

  one_debug "To load \$ONE_DIR/$1"
  before=$(_one_now)

  # shellcheck disable=SC1090

  if ! . "$ONE_DIR/$1"; then
    # shellcheck disable=2034
    ONE_LOADED=failed
  fi

  now=$(_one_now)
  local elapsed=$(( now - before ))

  if (( elapsed > ONE_DEBUG_SLOW_LOAD )); then
    one_debug "%bLoaded %s in %sms%b" "$YELLOW" "\$ONE_DIR/$1" $elapsed "$RESET_ALL"
  else
    one_debug "%bLoaded %s in %sms%b" "$GREY" "\$ONE_DIR/$1" $elapsed "$RESET_ALL"
  fi
}
