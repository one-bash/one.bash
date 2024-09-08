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

	local filename="${filepath##*/}"
	local mod_name mod_type repo_name

	if [[ $filename =~ ^[[:digit:]]{3}---([^@]+)@([^@]+)@([^@]+).bash$ ]]; then
		mod_name=${BASH_REMATCH[1]}
		repo_name=${BASH_REMATCH[2]}
		mod_type=${BASH_REMATCH[3]}
	else
		printf '%b%s%b\n' "$RED" "[one.bash] To load enabled module, but get invalid filename: $filename" "$RESET_ALL" >&2
		return "$ONE_EX_SOFTWARE"
	fi
	# echo "mod_name=$mod_name , mod_type=$mod_type"

	# shellcheck disable=1090
	source "$filepath" \
		1> >(awk "{print \"[one.bash][${repo_name}/${mod_type}/${mod_name}]: \" \$0}") \
		2> >(awk "{print \"${RED_ESC}[one.bash][${repo_name}/${mod_type}/${mod_name}]: \" \$0 \"${RESET_ALL_ESC}\"}" >&2) ||
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
		one_debug "%bLoaded in %sms%b" "$YELLOW" "$elapsed" "$RESET_ALL"
	else
		one_debug "%bLoaded in %sms%b" "$GREY" "$elapsed" "$RESET_ALL"
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
