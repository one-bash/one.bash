# ONE_LOG_FILE defined in one.config.default.bash

log_err() {
  local tag=$1
  shift 1
  local msg="$*"
  echo "$msg" >&2
  printf "[%s][ERROR][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" &>> "$ONE_LOG_FILE"
}

log_warn() {
  local tag=$1
  shift 1
  local msg="$*"
  echo "$msg" >&2
  printf "[%s][WARN][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" &>> "$ONE_LOG_FILE"
}

log_info() {
  local tag=$1
  shift 1
  local msg="$*"
  echo "$msg"
  printf "[%s][INFO][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" &>> "$ONE_LOG_FILE"
}

log_verb() {
  printf "[%s][VERB][$1] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$2" &>> "$ONE_LOG_FILE"
}
