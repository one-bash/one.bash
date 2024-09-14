# Provide functions for one.bash modules

one_stdout() {
	printf '[one.bash] %s\n' "$*"
}

one_stderr() {
	printf '%b[one.bash] %s%b\n' "$RED" "$*" "$RESET_ALL" >&2
}

# Check command existed
# @param command_name
one_check_cmd() {
	local cmd="$1"
	if one_l.has_not command "$cmd"; then
		echo "Not found command '$cmd'." >&2
		return "$ONE_EX_UNAVAILABLE"
	fi
	return 0
}

_one_precmd_functions_has_func() {
	local f
	for f in "${precmd_functions[@]}"; do
		if [[ ${f} == "${1}" ]]; then
			return 0
		fi
	done
	return 1
}

one_PATH_append() {
	local path=$1
	if [[ ! -d $path ]] || [[ $PATH =~ $path ]]; then return 0; fi
	PATH="$PATH:$path"
}

one_PATH_insert() {
	local path=$1
	if [[ ! -d $path ]] || [[ $PATH =~ $path ]]; then return 0; fi
	PATH="$path:$PATH"
}

one_MANPATH_append() {
	local path=$1
	if [[ ! -d $path ]] || [[ $MANPATH =~ $path ]]; then return 0; fi
	MANPATH="$MANPATH:$path"
}

one_MANPATH_insert() {
	local path=$1
	if [[ ! -d $path ]] || [[ $MANPATH =~ $path ]]; then return 0; fi
	MANPATH="$path:$MANPATH"
}

# Add function to PROMPT_COMMAND
# @param function_name
one_prompt_append() {
	local prompt_re

	if [[ -n ${bash_preexec_imported:-} ]]; then
		# We are using bash-preexec
		if ! _one_precmd_functions_has_func "$1"; then
			precmd_functions+=("$1")
		fi
	else
		if [[ $ONE_OS == MacOS ]]; then
			prompt_re="[[:<:]]${1}[[:>:]]"
		else
			# Linux, BSD, etc.
			prompt_re="\\<${1}\\>"
		fi

		if [[ ${PROMPT_COMMAND:-} =~ $prompt_re ]]; then
			return 0
		elif [[ -z ${PROMPT_COMMAND:-} ]]; then
			PROMPT_COMMAND="${1}"
		else
			PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
		fi
	fi
}
