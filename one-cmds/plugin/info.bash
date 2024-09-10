usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t info [OPTIONS] <NAME>
Desc:  Show info of matched $t
Arguments:
  <NAME>									$t name
Options:
  -r <repo>								Show the matched $t in the repo
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
			local ABOUT URL SCRIPT PRIORITY
			local link_to

			if [[ -z $repo ]]; then
				repo=$(get_enabled_repo_name "$filepath")
			fi

			link_to=$(get_enabled_link_to "$name" "$repo")

			print_info_item Name "$name"
			print_info_item Status "$([[ -n $link_to ]] && echo enabled || echo disabled)"
			print_info_item Repo "$repo"
			print_info_item "Path" "$link_to"
			print_info_item "Source" "$filepath"

			if [[ $filepath == *.opt.bash ]]; then
				(
					# shellcheck disable=1090
					source "$filepath"
					print_info_item "About" "${ABOUT:-}"
					print_info_item "Priority" "${PRIORITY:-}"
					print_info_item "URL" "${URL:-}"
					print_info_item "Script" "${SCRIPT:-}"
					print_info_item "DEP_CMDS" "${DEP_CMDS:-}"
				)
			else
				ABOUT=$(metafor about-plugin <"$filepath")
				PRIORITY=$(get_priority "$filepath")
				print_info_item "About" "${ABOUT:-}"
				print_info_item "Priority" "${PRIORITY:-}"
			fi
			;;

		0)
			print_err "No matched $t '$name'"
			return "$ONE_EX_DATAERR"
			;;

		*)
			print_err "Matched multi $t for '$name'. You should use -r option for specified repo:"
			for filepath in "${filepaths[@]}"; do
				local repo=$(get_enabled_repo_name "$filepath")
				echo "   one $t info $name -r $repo" >&2
			done
			return "$ONE_EX_USAGE"
			;;
	esac
}

main() {
	. "$ONE_DIR/one-cmds/mod.bash"
	if (($# == 0)); then usage; else info_mod "${args[0]}"; fi
}
