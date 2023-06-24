# ONE_LOG_FILE defined in one.config.default.bash

log_err() {
  local tag=$1
  shift 1
  local msg="$*"
  printf "[%s][ERROR][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" | tee -a "$ONE_LOG_FILE" >&2
}

log_warn() {
  local tag=$1
  shift 1
  local msg="$*"
  printf "[%s][WARN][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" | tee -a "$ONE_LOG_FILE" >&2
}

log_info() {
  local tag=$1
  shift 1
  local msg="$*"
  printf "[%s][INFO][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" | tee -a "$ONE_LOG_FILE" >&2
}

log_verb() {
  local tag=$1
  shift 1
  local msg="$*"
  printf "[%s][VERB][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" | tee -a "$ONE_LOG_FILE" >&2
}
