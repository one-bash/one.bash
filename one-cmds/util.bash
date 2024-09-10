_get_action() {
	local action=$1

	if [[ -n ${action_aliases[$action]:-} ]]; then
		echo "${action_aliases[$action]}"
	elif [[ ! -f "$ONE_DIR/one-cmds/$cmd/$action.bash" ]]; then
		print_err "Invalid action '$action' for command '$cmd'"
		return "$ONE_EX_USAGE"
	else
		echo "$action"
	fi
}

_show_usage() {
	if l.is_function usage; then
		usage
	else
		printf '<NO USAGE. PLEASE REPORT BUG TO https://github.com/one-bash/one.bash/issues>'
	fi
}

_parse_help() {
	local action
	local last_param=${*: -1}

	if (($# == 0)); then
		_show_usage
		exit 0
	elif [[ $1 == -h ]] || [[ $1 == --help ]]; then
		if (($# > 1)); then
			action=$(_get_action "$2")
			# shellcheck disable=1090
			. "$ONE_DIR/one-cmds/$cmd/$action.bash"
			"usage"
		else
			_show_usage
		fi
		exit 0
	elif [[ $last_param == -h ]] || [[ $last_param == --help ]]; then
		if (($# > 1)); then
			action=$(_get_action "$1")
			# shellcheck disable=1090
			. "$ONE_DIR/one-cmds/$cmd/$action.bash"
			"usage"
		else
			_show_usage
		fi
		exit 0
	fi
}

# @param cmd
# @param actions
# @param $@
_parse_completion() {
	if [[ ${3:-} != --complete ]]; then return; fi

	local cmd=$1
	local -n _actions=$2
	shift 2

	if ((COMP_CWORD < 3)); then
		# completion for cmd/main file

		if type -t "completion" &>/dev/null; then
			"completion" "$@"
		else
			local words=("${_actions[@]}" -h --help)
			printf '%s\n' "${words[@]}"
		fi

	elif [[ $2 == -h ]] || [[ $2 == --help ]]; then
		printf '%s\n' "${_actions[@]}"
	else
		local action
		action="$(_get_action "$2")"

		if [[ -f $ONE_DIR/one-cmds/$cmd/$action.bash ]]; then
			# shellcheck disable=1090
			. "$ONE_DIR/one-cmds/$cmd/$action.bash"

			shift 2
			COMP_CWORD=$((COMP_CWORD - 2))

			if type -t "completion" &>/dev/null; then
				"completion" "$@"
			fi
		fi
	fi

	exit 0
}

parse_cmd() {
	local cmd=$1
	shift

	_parse_completion "$cmd" actions "$@"

	_parse_help "$@"

	action=$(_get_action "$1")
	shift

	if [[ ! -f "$ONE_DIR/one-cmds/$cmd/$action.bash" ]]; then
		print_err "Invalid action: $action"
		return "$ONE_EX_USAGE"
	fi

	# shellcheck disable=1090
	. "$ONE_DIR/one-cmds/$cmd/$action.bash"

	declare -A opts=()
	declare -a args=()
	if l.is_associative_array opts_def; then
		opts_def[opts]=opts
		opts_def[args]=args
	else
		declare -A opts_def=(
			[opts]=opts
			[args]=args
		)
	fi
	l.parse_args opts_def "$@"

	main "$@"
}

print_err() {
	printf "%b[Error] %s%b\n" "$RED" "$1" "$RESET_ALL" >&2
}

print_warn() {
	printf "%b[WARN] %s%b\n" "$YELLOW" "$1" "$RESET_ALL" >&2
}

print_success() {
	printf "%b[Success] %s%b\n" "$GREEN" "$1" "$RESET_ALL"
}

print_verb() {
	printf "%b[Verbose] %s%b\n" "$GREY" "$1" "$RESET_ALL"
}
