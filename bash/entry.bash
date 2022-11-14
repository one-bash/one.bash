# If not running interactively, don't do anything
[[ -z "${PS1:-}" ]] && return 0

# Only execute this file once if loading or loaded
[[ -n "${ONE_LOADED:-}" ]] && return 0
ONE_LOADED=loading

if [[ -z ${ONE_DIR:-} ]]; then
  echo "ONE_DIR cannot be empty." >&2
  ONE_LOADED=failed
  return 78
fi

export ONE_DIR ONE_SUB ONE_CONF ONE_SHARE_DIR

if [[ -z ${EPOCHREALTIME:-} ]]; then
  _one_now() { date +%s000; }
else
  _one_now() { echo $(( ${EPOCHREALTIME/./} / 1000 )); }
fi

ONE_LOAD_START_TIME=$(_one_now)

# shellcheck source=./exit-codes.bash
. "$ONE_DIR/bash/exit-codes.bash"

# shellcheck source=./load-config.bash
. "$ONE_DIR/bash/load-config.bash"

# shellcheck source=../deps/colors.bash
. "$ONE_DIR/deps/colors.bash"

# shellcheck source=./debug.bash
. "$ONE_DIR/bash/debug.bash"

# shellcheck source=./one-load.bash
. "$ONE_DIR/bash/one-load.bash"

# shellcheck source=./path.bash
_one_load "bash/path.bash"

# shellcheck source=./xdg.bash
_one_load "bash/xdg.bash"

# shellcheck source=./failover.bash
_one_load "bash/failover.bash"

if [[ -n $ONE_RC ]]; then
  one_debug "To enter $ONE_RC"
  # shellcheck disable=SC1090
  . "$ONE_RC"
  ONE_LOADED=loaded
  return 0
fi

one_debug "To check shell"
# shellcheck source=./check-environment.bash
if ! check_shell; then one_failover; return 0; fi

# ---------------------- Load Optional Functions Below ------------------------

# shellcheck source-path=SCRIPTDIR/../
_one_load "deps/composure/composure.sh"

# shellcheck source=./helper.bash
_one_load "bash/helper.bash"

# shellcheck source=./env.bash
_one_load "bash/env.bash"

# Fig: https://github.com/withfig/fig
[[ $ONE_FIG == true ]] && eval "$(fig init bash pre)"

# shellcheck source=./one-complete.bash
_one_load "bash/one-complete.bash"

# shellcheck source=./enable-mods.bash
[[ $ONE_NO_MODS == false ]] && _one_load "bash/enable-mods.bash"

[[ $ONE_FIG == true ]] && eval "$(fig init bash post)"

ONE_LOAD_END_TIME=$(_one_now)
one_debug "${GREEN}%s${RESET_ALL}" "loaded success (Total $(( ONE_LOAD_END_TIME - ONE_LOAD_START_TIME ))ms)"
ONE_LOADED=loaded
