# ONE_LOG_FILE defined in one.config.default.bash

log_err() {
	local tag=$1
	shift 1
	local msg="$*"
	printf "%b[%s][ERROR][$tag] %s%b\n" "$RED" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" "$RESET_ALL" | tee -a "$ONE_LOG_FILE" >&2
}

log_warn() {
	local tag=$1
	shift 1
	local msg="$*"
	printf "%b[%s][WARN][$tag] %s%b\n" "$YELLOW" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" "$RESET_ALL" | tee -a "$ONE_LOG_FILE" >&2
}

log_info() {
	local tag=$1
	shift 1
	local msg="$*"
	printf "[%s][INFO][$tag] %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" "$RESET_ALL" | tee -a "$ONE_LOG_FILE" >&2
}

log_verb() {
	local tag=$1
	shift 1
	local msg="$*"
	printf "%b[%s][VERB][$tag] %s%b\n" "$GREY" "$(date +"%Y-%m-%d %H:%M:%S")" "$msg" "$RESET_ALL" | tee -a "$ONE_LOG_FILE" >&2
}
