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

	local filename mod_name mod_type
	filename=$(basename "$filepath")
	case $filename in
		*.plugin.bash)
			mod_name=${filename:6:-12}
			mod_type=plugin
			;;
		*.completion.bash)
			mod_name=${filename:6:-16}
			mod_type=completion
			;;
		*.alias.bash)
			mod_name=${filename:6:-11}
			mod_type='alias'
			;;
		*)
			echo "[_load_enabled] Invalid filename=$filename" >&2
			return 4
			;;
	esac

	# shellcheck disable=SC1090
	source "$filepath" \
		1> >(awk "{print \"[one.bash ${mod_type}/${mod_name}]: \" \$0}") \
		2> >(awk "{print \"${RED_ESC}[one.bash ${mod_type}/${mod_name}]: \" \$0 \"${RESET_ALL_ESC}\"}" >&2) ||
		load_failed "$?"
}

_load_enabled_with_debug() {
	local filepath=$1
	one_debug "To load module: ${filepath/$ONE_DIR/\$ONE_DIR}"

	local before now
	before=$(_one_now)

	_load_enabled "$filepath"

	now=$(_one_now)
	local elapsed=$((now - before))

	if ((elapsed > ONE_DEBUG_SLOW_LOAD)); then
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
	while read -r filepath; do
		paths+=("$filepath")
	done < <(sort <(compgen -G "$ONE_DIR/enabled/*.bash" || true))

	cite about-plugin

	local load
	if [[ $ONE_DEBUG == true ]]; then
		load=_load_enabled_with_debug
	else
		load=_load_enabled
	fi

	for filepath in "${paths[@]}"; do
		$load "$filepath"
	done
}

load_enabled
unset -f load_enabled _load_enabled _load_enabled_with_debug load_failed
