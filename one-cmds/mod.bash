# shellcheck source=./mod-base.bash
. "$ONE_DIR/one-cmds/mod-base.bash"

readonly -A default_priority_map=(
	[plugin]=400
	[completion]=600
	[alias]=750
	[bin]=---
	[sub]=---
)

# $t are defined in caller

# @param mod_type
list_enabled() {
	shopt -s nullglob
	local path
	for path in "$ONE_DIR"/enabled/*---*"@$1.bash"; do
		path=${path##*---}
		echo "${path%%@*}"
	done
}

# @param filepath
get_enabled_repo_name() {
	local s="$ONE_DIR/enabled/repo/"
	repo=${1:${#s}}
	echo "${repo%%/*}"
}

disable_mod() {
	local name=$1
	if (($# > 1)); then
		local -n _found_=$2
	else
		local _found_
	fi

	_found_=false

	local filepath filename target
	shopt -s nullglob
	# shellcheck disable=2154
	for filepath in "$ONE_DIR/enabled/"*---"$name@"*"@$t.bash"; do

		local filename="${filepath##*/}"

		if [[ $filename =~ ^[[:digit:]]{3}---([^@]+)@([^@]+)@([^@]+).bash$ ]]; then
			mod_name=${BASH_REMATCH[1]}
			repo_name=${BASH_REMATCH[2]}
			mod_type=${BASH_REMATCH[3]}
			if [[ -f ${ONE_DIR}/enabled/repo/$repo_name/$mod_type/${mod_name}.opt.bash ]]; then
				(
					. "${ONE_DIR}/enabled/repo/$repo_name/$mod_type/${mod_name}.opt.bash"

					local path target name
					if l.is_array BIN; then
						for path in "${BIN[@]}"; do
							if [[ -L $path ]]; then
								name=${path##*/}
								unlink "$ONE_DIR/enabled/bin/$name"
								target="$(readlink "$path")"
								printf "Disabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$target"
							fi
						done
					fi
				)
			fi
		fi

		unlink "$filepath"

		echo "Disabled ${filename}. Please restart shell to take effect."
		_found_=true
	done
}

check_file() {
	local name=$1
	# shellcheck disable=2154
	if [[ ! -f "$t_dir/$name.bash" ]]; then
		print_err "No matched $t '$name'"
		exit 1
	fi
}

# Search in <repo>/<mod_type>/<name>.bash or <repo>/<mod_type>/<name>.opt.bash
search_mod() {
	local name=$1
	local repo=$2
	local -n output=$3
	local path

	shopt -s nullglob
	if [[ -z $repo ]]; then
		for path in "$ONE_DIR"/enabled/repo/*/"$t/$name"{,.bash,.sh,.opt.bash}; do
			output+=("$path")
		done
	else
		for path in "$ONE_DIR/enabled/repo/$repo/$t/$name"{,.bash,.sh,.opt.bash}; do
			if [[ -f $path ]]; then
				output+=("$path")
			fi
		done
	fi
}

_ask_update_mod_data() {
	local target=$1
	local answer

	if [[ -e $target ]]; then
		local prompt
		prompt=$(printf '%b[Mod=%s] %s%b' "$YELLOW" "$name" "Found existed data which may be outdated. Update it to latest?" "$RESET_ALL")
		answer=$(l.ask "$prompt" N)

		if [[ ${answer} == YES ]]; then
			rm -rf "$target"
		else
			return 1
		fi
	fi
}

download_github_release_files() {
	local isEmpty=yes answer

	shopt -s nullglob
	for _ in "$MOD_DATA_DIR"/*; do
		isEmpty=no
		break
	done

	if [[ $isEmpty == no ]]; then
		local prompt
		prompt=$(printf '%b[Mod=%s] %s%b' "$YELLOW" "$name" "Found existed data which may be outdated. Update it to latest?" "$RESET_ALL")
		answer=$(l.ask "$prompt" N)

		if [[ $answer == YES ]]; then
			rm -rf "$MOD_DATA_DIR"
			mkdir "$MOD_DATA_DIR"
		else
			return 0
		fi
	fi

	local version="${GITHUB_RELEASE_VERSION:-latest}"

	local file
	for file in "${GITHUB_RELEASE_FILES[@]}"; do
		if [[ $version == latest ]]; then
			url="${GIT_REPO:-${GITHUB_REPO:-}}/releases/latest/download/$file"
		else
			url="${GIT_REPO:-${GITHUB_REPO:-}}/releases/download/$version/$file"
		fi

		print_verb 'To download file "%s" from %s\n' "$file" "$url"
		curl -fLo "$MOD_DATA_DIR/$file" "$url"
	done
}

download_mod_data() {
	local name=$1 opt_path=$2
	local SCRIPT answer GIT_REPO

	local MOD_DATA_ROOT="$ONE_DIR/data/$t"
	local MOD_DATA_DIR="$MOD_DATA_ROOT/${name}"
	mkdir -p "$MOD_DATA_DIR"

	(
		. "$opt_path"

		GIT_REPO=${GIT_REPO:-${GITHUB_REPO:-}}

		if [[ -n $GIT_REPO ]]; then
			local target="$MOD_DATA_DIR/git"

			if [[ -n ${GITHUB_RELEASE_FILES:-} ]]; then
				download_github_release_files
			else
				if _ask_update_mod_data "$target"; then
					print_verb 'To git clone "%s" "%s"\n' "$GIT_REPO" "$target"

					local -a clone_opts=(
						--depth 1 --single-branch --recurse-submodules --shallow-submodules
					)
					if [[ -n ${GIT_BRANCH:-} ]]; then clone_opts+=(--branch "$GIT_BRANCH"); fi

					git clone "${clone_opts[@]}" "$GIT_REPO" "$target"
				fi
			fi
		elif [[ -n ${SCRIPT:-} ]]; then
			local target="$MOD_DATA_DIR/script.bash"
			if _ask_update_mod_data "$target"; then
				if [[ $SCRIPT =~ ^https?:// ]] || [[ $SCRIPT =~ ^ftp:// ]]; then
					print_verb 'To curl -fLo "%s" "%s"\n' "$target" "$SCRIPT"
					curl -fLo "$target" "$SCRIPT"
				elif [[ $SCRIPT =~ ^/ ]]; then
					cp "$SCRIPT" "$target"
				else
					echo "Unsupported script value: $SCRIPT" >&2
					return 33
				fi
			fi
		fi
	)
}

# @param $1 The filepath that stores options
# @param $2 The key
get_opt() {
	# shellcheck disable=1090
	(source "$1" && eval "echo \"\${$2:-}\"")
}

# @param $1 The filepath that stores options
# @param $2 The key
get_opt_array() {
	# shellcheck disable=1090
	(source "$1" && eval "echo \"\${$2[@]:-}\"")
}

# @param mod_filepath
# @param mod_type
get_priority() {
	local priority

	# NOTE: grep -Eo not match "\d" in Linux. "\d" is part of a Perl-compatible regular expression (PCRE).
	priority=$(head "$1" | grep -Eo '^# (ONE|BASH_IT)_LOAD_PRIORITY: [0-9]{3}$' | grep -Eo '[0-9]{3}' || true)

	if [[ -z $priority ]]; then
		echo "${default_priority_map[$2]}"
	else
		echo "$priority"
	fi
}

# @param mod_name
# @param mod_type
get_priority_from_mod() {
	priority=$(get_opt "$1" PRIORITY)
	if [[ -z $priority ]]; then
		echo "${default_priority_map[$2]}"
	else
		echo "$priority"
	fi
}

# @param mod_name
# @param repo
# @param mod_type
get_enabled_link_to() {
	local path
	shopt -s nullglob
	path=$(echo "$ONE_DIR/enabled/"*---"$1@$2@$3.bash")
	if [[ -L $path ]]; then
		readlink "$path"
	fi
}

# @param mod_filepath
mod_check_dep_cmds() {
	local path=$1
	local -a DEPS

	if [[ $path == *.opt.bash ]]; then
		# shellcheck disable=2207
		IFS=' ' DEPS=($(get_opt "$path" DEPS))
	else
		# shellcheck disable=2207
		IFS=' ' DEPS=($(metafor one-bash:mod:deps <"$path"))
	fi

	local cmd
	for cmd in "${DEPS[@]}"; do
		if one_l.has_not command "$cmd"; then
			print_err "The command '%s' is required. But not found it in system. Please install the command first. \nSee %s to install it.\n" \
				"$cmd" "https://command-not-found.com/$cmd"
			return 11
		fi
	done
}

declare -A MOD_TYPE_COLOR=(
	[completion]=$GREEN
	[plugin]=$BLUE
	[alias]=$PURPLE
	[bin]=$WHITE
	[sub]=$YELLOW
)

# @param mod_filepath
print_mod_props() {
	local filepath=$1
	local -a prints=()
	local format='' about='' repo_name mod_type mod_name

	if [[ $filepath =~ \/repo\/([^\/]+)\/([^\/]+)\/([^\/]+) ]]; then
		repo_name="${BASH_REMATCH[1]}"
		mod_type="${BASH_REMATCH[2]}"
		mod_name="${BASH_REMATCH[3]}"
		mod_name=${mod_name##*/}

		if [[ $mod_name == *.opt.bash ]]; then
			mod_name=${mod_name%.opt.bash}
			# shellcheck disable=1090,2153
			about="$(. "$filepath" && echo "${ABOUT:-}")"
			priority=$(get_priority_from_mod "$filepath" "$mod_type")
		else
			mod_name=${mod_name%.bash}
			about=$(metafor about-plugin <"$filepath")
			priority=$(get_priority "$filepath" "$mod_type")
		fi

		# mod status
		format="%b%s"
		link_to=$(get_enabled_link_to "$mod_name" "$repo_name" "$mod_type")
		if [[ -n $link_to ]]; then
			prints+=("$GREEN" "[x]")
		else
			prints+=("$GREY" "[ ]")
		fi

		# load-priority
		format="$format %b%-4s"
		prints+=("$YELLOW" "$priority")

		# mod type
		format="$format %b%-4s"
		local mod_type_str=${mod_type^}
		prints+=("${MOD_TYPE_COLOR[$mod_type]}" "${mod_type_str:0:4}")

		# mod_name repo_name
		format="$format %b%-18s %b%-18s"

		prints+=(
			"$CYAN" "${mod_name:0:18}"
			"$BLUE" "${repo_name:0:18}"
		)

		# About
		format="$format %b%s"
		prints+=("$WHITE" "${about//$'\n'/ }")

		# shellcheck disable=2059
		printf "$format\n" "${prints[@]}"
	fi
}

# @param mod_filepath
# @param [repo_filter]
print_enabled_mod_props() {
	local filepath=${1}
	local filename=${filepath##*/}
	local repo_filter=${2:-}
	local filename mod_type mod_type mod_name repo_name priority

	if [[ $filename =~ ^([[:digit:]]{3})---([^@]+)@([^@]+)@([^@]+).bash$ ]]; then
		priority="${BASH_REMATCH[1]}"
		mod_name=${BASH_REMATCH[2]}
		repo_name=${BASH_REMATCH[3]}
		mod_type=${BASH_REMATCH[4]}
	else
		# ignore invalid file
		return 0
	fi

	if [[ -n $repo_filter ]] && [[ $repo_filter != "$repo_name" ]]; then
		return 0
	fi

	local -a prints=()
	local format='' about

	# load-priority
	format="$format%b%-4s"
	prints+=("$YELLOW" "$priority")

	# mod type
	format="$format %b%-4s"
	local mod_type_str=${mod_type^}
	prints+=("${MOD_TYPE_COLOR[${mod_type}]}" "${mod_type_str:0:4}")

	# mod_name repo_name
	format="$format %b%-18s %b%-18s"

	prints+=(
		"$CYAN" "${mod_name:0:18}"
		"$BLUE" "${repo_name:0:18}"
	)

	# About
	format="$format %b%s"
	about=$(metafor about-plugin <"$filepath")
	prints+=("$WHITE" "${about//$'\n'/ }")

	# shellcheck disable=2059
	printf "$format\n" "${prints[@]}"
}

create_bin_symlink() {
	local name=$1 type=$2 target=$3

	ln -fs "$target" "$ONE_DIR/enabled/$type/$name"
	printf "Enabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$target"
}
