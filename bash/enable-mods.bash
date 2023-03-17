# shellcheck disable=2317

load_failed() {
  local exit_code=$1
  printf '%b[one.bash] Failed to load module "%s" (exit_code=%s). You can disable it by "%s".\n%b' \
    "$YELLOW" "$filename" "$exit_code" \
    "one ${mod_type} disable ${mod_name}" \
    "$RESET_ALL" >&2
}

_load_enabled() {
  local filepath=$1
  set -- # prevent the sourced script receiving the arguments of function _load_enabled

  local filename
  filename=$(basename "$filepath")
  # shellcheck disable=2207
  local list=( $(<<<"$filename" sed -E 's/^[[:digit:]]{3}---(.+)\.(.+)\.bash$/\1 \2/') )
  local mod_name="${list[0]}"
  local mod_type="${list[1]}"

  # shellcheck disable=SC1090
  source "$filepath" \
    1> >(sed -E "s|^(.+)|[one.bash ${mod_type}/${mod_name}]: \1|") \
    2> >(sed -E "s|^(.+)|${RED_ESC}[one.bash ${mod_type}/${mod_name}]: \1${RESET_ALL_ESC}|" >&2) \
    || load_failed "$?"
}

_load_enabled_with_debug() {
  local filepath=$1
  one_debug "To load module: ${filepath/$ONE_DIR/\$ONE_DIR}"

  local before now
  before=$(_one_now)

  _load_enabled "$filepath"

  now=$(_one_now)
  local elapsed=$(( now - before ))

  if (( elapsed > ONE_DEBUG_SLOW_LOAD )); then
    one_debug "%bLoaded in %sms%b" "$YELLOW" $elapsed "$RESET_ALL"
  else
    one_debug "%bLoaded in %sms%b" "$GREY" $elapsed "$RESET_ALL"
  fi
}

load_enabled() {
  one_debug "To load enabled modules"
  local filepath
  local -a paths

  # Because "<" make it in pipeline, and tty is missing in pipeline. So separate it into two iterations.
  while read -r filepath ; do
    paths+=("$filepath")
  done < <(sort <(compgen -G "$ONE_DIR/enabled/*.bash" || true))

  cite about-plugin

  local load
  if [[ $ONE_DEBUG == true ]]; then
    load=_load_enabled_with_debug
  else
    load=_load_enabled
  fi

  for filepath in "${paths[@]}" ; do
    $load "$filepath"
  done
}

load_enabled
unset -f load_enabled _load_enabled _load_enabled_with_debug load_failed
