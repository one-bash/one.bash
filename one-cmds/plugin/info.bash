usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t info [OPTIONS] <NAME>
Desc:  Show the information of matched $t
Arguments:
  <NAME>                    $t name
Options:
  -r <repo>                 Show the matched $t in the repo
EOF
	# editorconfig-checker-enable
}

. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

info_mod() {
	local name=$1
	local filepath
	local -a filepaths=()
	local repo="${opts[r]:-}"

	search_mod "$name" "$repo" filepaths

	case ${#filepaths[@]} in
		1)
			local filepath=${filepaths[0]}
			local ABOUT SCRIPT PRIORITY
			local link_to

			if [[ -z $repo ]]; then
				repo=$(get_enabled_repo_name "$filepath")
			fi

			link_to=$(get_enabled_link_to "$name" "$repo" "$t")

			PRINT_INFO_KEY_WIDTH=12

			print_info_item Name "$name"
			print_info_item Status "$([[ -n $link_to ]] && echo enabled || echo disabled)"
			print_info_item Repo "$repo"

			if [[ $filepath == *.opt.bash ]]; then
				(
					# shellcheck disable=1090
					source "$filepath"
					ABOUT=${ABOUT:-}
					print_info_item About "${ABOUT//$'\n'/ }"
					if [[ -z ${PRIORITY:-} ]]; then
						print_info_item Priority "${default_priority_map[$t]}"
					else
						print_info_item Priority "${PRIORITY}"
					fi

					print_info_item DEPS "${DEPS:-}"
					print_info_item GIT_REPO "${GIT_REPO:-${GITHUB_REPO:-}}"
					print_info_item GITHUB_RELEASE_VERSION "${GITHUB_RELEASE_VERSION:-}"
					print_info_item GITHUB_RELEASE_FILES "${GITHUB_RELEASE_FILES:-}"
					print_info_item Script "${SCRIPT:-}"
				)
			else
				ABOUT=$(metafor about-plugin <"$filepath")
				PRIORITY=$(get_priority "$filepath" "$t")
				DEPS=$(metafor one-bash:mod:deps <"$filepath")

				print_info_item About "${ABOUT//$'\n'/ }"
				print_info_item Priority "${PRIORITY}"
				print_info_item DEPS "${DEPS}"
			fi

			print_info_item Path "$link_to"
			print_info_item Source "$filepath"
			;;

		0)
			print_err "No matched $t '$name'"
			return "$ONE_EX_DATAERR"
			;;

		*)
			print_err "Matched multi $t for '$name'. You should use '-r' option for specified repo:"
			local repo
			for filepath in "${filepaths[@]}"; do
				repo=$(get_enabled_repo_name "$filepath")
				echo "   one $t info $name -r $repo" >&2
			done
			return "$ONE_EX_USAGE"
			;;
	esac
}

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi
	. "$ONE_DIR/one-cmds/mod.bash"
	info_mod "${args[0]}"
}
