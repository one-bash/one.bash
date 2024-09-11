usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t enable [OPTIONS] <NAME> [<NAME>...]
Desc:  Enable matched $t
Arguments:
  <NAME>                  $t name
Options:
  -r <repo>               Enable matched $t in the repo
EOF
	# editorconfig-checker-enable
}

# Create completion mod file
create_mod() {
	local name=$1 opt_path=$2
	local MOD_DATA_ROOT="$ONE_DIR/data/$t"
	local MOD_DATA_DIR="$MOD_DATA_ROOT/${name}"
	local MOD_FILE="$MOD_DATA_DIR/mod.bash"
	local MOD_META="$MOD_DATA_DIR/meta.bash"
	local log_tag="enable:$t:$name"
	local repo_name
	local PRIORITY SCRIPT APPEND INSERT ABOUT URL RUN

	repo_name=$(get_enabled_repo_name "$opt_path")
	log_verb "$log_tag:mod_meta" "opt_path=$opt_path repo_name=$repo_name"

	APPEND=$(get_opt "$opt_path" APPEND)
	INSERT=$(get_opt "$opt_path" INSERT)
	RUN=$(get_opt "$opt_path" RUN)

	if [[ -n ${RUN:-} ]]; then
		log_verb "$log_tag:RUN" "$RUN"
		# shellcheck disable=2094
		(eval "$RUN" 2>&1 1>>"$ONE_LOG_FILE" | tee -a "$ONE_LOG_FILE" >&2) ||
			{
				log_err "$log_tag:RUN" "Failed to execute cmd: $RUN"
				return 7
			}
	fi

	PRIORITY=$(get_opt "$opt_path" PRIORITY)
	ABOUT=$(get_opt "$opt_path" ABOUT)
	SCRIPT=$(get_opt "$opt_path" SCRIPT)
	URL=$(get_opt "$opt_path" URL)

	{
		echo "$mod_annotation"
		echo "repo_name=$repo_name"
	} >"$MOD_META"

	echo "$mod_annotation" >"$MOD_FILE"

	{
		if [[ -n ${ABOUT:-} ]]; then
			printf '# About: %s\n' "$ABOUT"
		fi

		if [[ -n ${PRIORITY:-} ]]; then
			echo "# ONE_LOAD_PRIORITY: $PRIORITY"
		fi

		if [[ -n ${INSERT:-} ]]; then
			log_verb "$log_tag:INSERT" "$INSERT"
			printf '\n'
			(eval "$INSERT" 2> >(tee -a "$ONE_LOG_FILE" >&2)) ||
				{
					log_err "$log_tag:INSERT" "[Failed] $INSERT"
					return 8
				}
		fi

		if [[ -n ${URL:-} ]]; then
			if l.end_with "$URL" '.git'; then
				if [[ -n ${SCRIPT:-} ]]; then
					echo "source \"\$ONE_DIR/data/$t/$name/${SCRIPT}\""
				fi
			else
				echo "source \"\$ONE_DIR/data/$t/$name/script.bash\""
			fi
		fi

		if [[ -n ${APPEND:-} ]]; then
			log_verb "$log_tag:APPEND" "$APPEND"
			printf '\n'
			(eval "$APPEND" 2> >(tee -a "$ONE_LOG_FILE" >&2)) ||
				{
					log_err "$log_tag:APPEND" "[Failed] $APPEND"
					return 9
				}
		fi
	} >>"$MOD_FILE"

	echo "$MOD_FILE"
}

enable_file() {
	local name=$1 repo=$2 filepath=$3 priority
	priority=$(get_priority "$filepath")

	ln -sf "$filepath" "$ENABLED_DIR/$priority---$name@$repo@$t.bash"

	printf 'Enabled %b%s%b with priority=%b%s%b. Please restart shell to take effect.\n' \
		"$BLUE" "$repo/$t/$name" "$RESET_ALL" \
		"$YELLOW" "$priority" "$RESET_ALL"
}

enable_mod() {
	local name=$1 repo=$2 repo_name
	local -a filepaths=()

	search_mod "$name" "$repo" filepaths

	case ${#filepaths[@]} in
		1)
			local filepath=${filepaths[0]}
			repo_name=${filepath#"$ONE_DIR/enabled/repo/"}
			repo_name=${repo_name%%/*}

			if [[ $filepath == *.opt.bash ]]; then
				check_opt_mod_dep_cmds "$filepath"
				# Disable first, prevent duplicated module enabled with different priority
				disable_mod "$name"
				download_mod_data "$name" "$filepath"
				filepath=$(create_mod "$name" "$filepath")
				[[ -z $filepath ]] && return
			else
				# Disable first, prevent duplicated module enabled with different priority
				disable_mod "$name"
			fi

			enable_file "$name" "$repo_name" "$filepath" || print_err "Failed to enable '$name'."
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
				echo "   one $t enable $name -r $repo" >&2
			done
			return "$ONE_EX_USAGE"
			;;
	esac
}

. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	. "$ONE_DIR/one-cmds/mod.bash"

	# shellcheck source=../../bash/load-config.bash
	. "$ONE_DIR/bash/load-config.bash"

	# shellcheck source=../../bash/log.bash
	. "$ONE_DIR/bash/log.bash"

	local name
	local repo="${opts[r]:-}"
	for name in "${args[@]}"; do
		#  BUG: when curl failed in download_mod_data(), the enable_mod() not stopped
		#       If remove || print_err "Failed to enable '$name'.", it will work well
		enable_mod "$name" "$repo" || print_err "Failed to enable '$name'."
	done
}
