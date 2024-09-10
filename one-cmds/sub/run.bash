usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one sub run [-h] <NAME> [<ARGS>...]
Desc:  Run sub command
Options:
  -h                    Print the usage of sub command
Arguments:
  <NAME>                Sub name
EOF
	# editorconfig-checker-enable
}

_one_is_completable() {
	grep -i '^# one.bash:completion' "$1" >/dev/null
}

completion() {
	local path

	if (($# < 2)) || [[ ${*: -1:1} == -h ]]; then
		for path in "$ONE_DIR"/enabled/sub/*; do
			if [[ -x $path ]]; then echo "${path##*/}"; fi
		done
	else
		path="$ONE_DIR/enabled/sub/$1"

		if [[ -f $path ]] && _one_is_completable "$path"; then
			shift 1
			# shellcheck disable=2097,2098
			COMP_CWORD=$((COMP_CWORD - 2)) "$path" --complete "$@"
		fi
	fi
}

main() {
	if (($# == 0)); then
		usage_run
		return "$ONE_EX_OK"
	fi

	local name=$1
	shift 1

	export ONE_LOBASH_FILE="$ONE_DIR/deps/lobash.bash"

	if [[ $name == -h ]]; then
		one sub help "$@"
	else
		if [[ -x "$ONE_DIR/enabled/sub/$name" ]]; then
			"$ONE_DIR/enabled/sub/$name" "$@"
		else
			print_err "No such sub command: $name"
			return "$ONE_EX_NOINPUT"
		fi
	fi
}
