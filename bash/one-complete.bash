_one_is_completable() {
	grep -i '^# one.bash:completion' "$1" >/dev/null
}

# @param cmd_dir  command directory
# @param cmd  command name
_one_sub_cmd_completion() {
	local cmd_path="$1"
	if [[ ! -x $cmd_path ]]; then return 0; fi

	if _one_is_completable "$cmd_path"; then
		shift 1
		# shellcheck disable=2097,2098
		COMP_CWORD=$COMP_CWORD "$cmd_path" --complete "$@"
	fi
}

_one_COMP_REPLY() {
	local str

	if [[ -z $word ]]; then
		while read -r str; do
			COMPREPLY+=("$str")
		done
	else
		while read -r str; do
			if [[ $str =~ ^"$word" ]]; then
				COMPREPLY+=("$str")
			fi
		done
	fi
}

_comp_one_bash_sub() {
	local word="${COMP_WORDS[COMP_CWORD]}"

	if ((COMP_CWORD == 1)); then
		shopt -s nullglob
		_one_COMP_REPLY < <(for path in "$ONE_DIR"/enabled/sub/*; do
			if [[ -x $path ]]; then
				echo "${path##*/}"
			fi
		done)

		_one_COMP_REPLY <<<'help'
	else
		# Expend options of sub command
		local cmd="${COMP_WORDS[1]}"
		local repo

		if [[ $cmd == help ]]; then
			_one_COMP_REPLY < <(_one_sub_cmd_completion "$ONE_DIR/one-cmds/help-sub" "${COMP_WORDS[@]:2}")
			return 0
		fi

		for repo in "${ONE_DIR}"/enabled/repo/*; do
			if [[ ! -d "$repo/sub" ]]; then continue; fi

			_one_COMP_REPLY < <(_one_sub_cmd_completion "$repo/sub/$cmd" "${COMP_WORDS[@]:2}")
		done
	fi
}

_comp_one_bash() {
	local word="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=()

	if ((COMP_CWORD == 1)); then
		# list commands of one.bash
		local path
		_one_COMP_REPLY < <(for path in "$ONE_DIR"/one-cmds/*; do
			if [[ -x $path/main ]] || [[ -x $path ]]; then
				echo "${path##"$ONE_DIR/one-cmds/"}"
			fi
		done)

		local words=(-h --help --bashrc)
		_one_COMP_REPLY < <(printf '%s\n' "${words[@]}")
	else
		local cmd
		cmd=$(_one_get_command_name "${COMP_WORDS[1]}")

		if [[ -d "$ONE_DIR/one-cmds/$cmd" ]]; then
			# Expend options of one command
			_one_COMP_REPLY < <(_one_sub_cmd_completion "$ONE_DIR/one-cmds/$cmd/main" "${COMP_WORDS[@]:2}")
		else
			# Expend options of one command
			_one_COMP_REPLY < <(_one_sub_cmd_completion "$ONE_DIR/one-cmds/$cmd" "${COMP_WORDS[@]:2}")
		fi
	fi
}

complete -F _comp_one_bash one

if [[ -n ${ONE_SUB:-} ]]; then
	# shellcheck disable=SC2139
	alias "$ONE_SUB"='one sub run ' # NOTE: the last space is essential
	complete -F _comp_one_bash_sub "$ONE_SUB"
fi
