# shellcheck source=./mod-base.bash
. "$ONE_DIR/one-cmds/mod-base.bash"

readonly -A default_priority_map=(
	[plugin]=400
	[completion]=600
	[alias]=750
	[bin]=---
	[sub]=---
)

readonly ENABLED_DIR=$ONE_DIR/enabled

# NOTE: DO NOT modify the value of mod_annotation
readonly mod_annotation='# This file is generated by one.bash. Do not edit the content by manual.'

# $t are defined in caller

# @param type
list_enabled() {
	find "$ENABLED_DIR" -maxdepth 1 \
		-name "*---*@$1.bash" \
		-exec basename {} \; |
		sed -E 's/^[[:digit:]]{3}---([^@]+)@[^@]+@[^@]+.bash$/\1/'
}

get_enabled_repo_name() {
	repo=${1#"$ONE_DIR/enabled/repo/"}
	echo "${repo%%/*}"
}

get_repo_name() {
	repo=${1#"$ONE_DIR/data/repo/"}
	echo "${repo%%/*}"
}

# List all paths matched $ENABLED_DIR/*---$name@$repo@$t.bash
match_enabled_modules() {
	local name=$1
	# shellcheck disable=2154
	compgen -G "$ENABLED_DIR/*---$name@*@$t.bash" || true
}

_disable_mod() {
	local filepath=$1
	local target
	target=$(readlink "$filepath")

	if [[ -e $target ]] && grep "^$mod_annotation" "$filepath" &>/dev/null; then
		unlink "$target"
	fi

	unlink "$filepath"
}

disable_mod() {
	local name=$1
	local filepath
	if (($# > 1)); then
		local -n _found_=$2
	else
		local _found_
	fi

	_found_=false

	while read -r -d $'\n' filepath; do
		if [[ -L $filepath ]] || [[ -f $filepath ]]; then
			_disable_mod "$filepath"
			echo "Disabled ${filepath##*/}. Please restart shell to take effect."
			_found_=true
		fi
	done < <(match_enabled_modules "$name")
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
		for path in "$ONE_DIR"/enabled/repo/*/"$t/$name"{.bash,.opt.bash}; do
			output+=("$path")
		done
	else
		for path in "$ONE_DIR/enabled/repo/$repo/$t/$name"{.bash,.opt.bash}; do
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
		prompt=$(printf '%b[Mod=%s] %s%b' "$YELLOW" "$name" "Found existed data which may be outdated. Update it to latest? (y/[n])" "$RESET_ALL")
		read -r -p "$prompt" answer

		if [[ ${answer:-n} == y ]]; then
			rm -rf "$target"
		else
			return 1
		fi
	fi
}

download_github_release_files() {
	if [[ -z ${GITHUB_REPO:-} ]] || [[ ! -v GITHUB_DOWNLOAD ]]; then
		return
	fi

	local version="${GITHUB_VERSION:-latest}"

	local file
	for file in "${GITHUB_DOWNLOAD[@]}"; do
		if [[ $version == latest ]]; then
			url="https://github.com/$GITHUB_REPO/releases/latest/download/$file"
		else
			url="https://github.com/$GITHUB_REPO/releases/download/$version/$file"
		fi

		printf 'To download file "%s" from %s\n' "$file" "$url" >&2
		curl -Lo "$MOD_DATA_DIR/$file" "$url"
	done
}

download_mod_data() {
	local name=$1 opt_path=$2
	local url answer

	local MOD_DATA_ROOT="$ONE_DIR/data/$t"
	local MOD_DATA_DIR="$MOD_DATA_ROOT/${name}"
	mkdir -p "$MOD_DATA_DIR"

	url=$(get_opt "$opt_path" URL)

	if [[ -n $url ]]; then
		if l.end_with "$url" '.git'; then
			local target="$MOD_DATA_DIR/git"
			if _ask_update_mod_data "$target"; then
				printf 'To git clone "%s" "%s"\n' "$url" "$target" >&2
				git clone --depth 1 --single-branch --recurse-submodules --shallow-submodules "$url" "$target"
			fi
		else
			local target="$MOD_DATA_DIR/script.bash"
			if _ask_update_mod_data "$target"; then
				printf 'To curl -Lo "%s" "%s"\n' "$target" "$url" >&2
				curl -Lo "$target" "$url"
			fi
		fi
	else
		local isEmpty=yes answer

		shopt -s nullglob
		for _ in "$MOD_DATA_DIR"/*; do
			isEmpty=no
			break
		done

		if [[ $isEmpty == no ]]; then
			local prompt
			prompt=$(printf '%b[Mod=%s] %s%b' "$YELLOW" "$name" "Found existed data which may be outdated. Update it to latest? (y/[n])" "$RESET_ALL")
			read -r -p "$prompt" answer

			if [[ ${answer:-n} == y ]]; then
				rm -rf "$MOD_DATA_DIR"
				mkdir "$MOD_DATA_DIR"
			else
				return
			fi
		fi

		(
			install() { return 0; }
			# shellcheck disable=1090
			source "$opt_path"
			download_github_release_files
			install
		)
	fi
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

get_priority() {
	local priority

	# NOTE: grep -Eo not match "\d" in Linux. "\d" is part of a Perl-compatible regular expression (PCRE).
	priority=$(head "$1" | grep -Eo '^# (ONE|BASH_IT)_LOAD_PRIORITY: [0-9]{3}$' | grep -Eo '[0-9]{3}' || true)

	if [[ -z $priority ]]; then
		echo "${default_priority_map[$t]}"
	else
		echo "$priority"
	fi
}

get_priority_from_mod() {
	priority=$(get_opt "$1" PRIORITY)
	if [[ -z $priority ]]; then
		echo "${default_priority_map[$t]}"
	else
		echo "$priority"
	fi
}

get_enabled_link_to() {
	local name=$1 repo=$2
	local path
	shopt -s nullglob
	path=$(echo "$ENABLED_DIR/"*---"$name@$repo@$t.bash")
	if [[ -L $path ]]; then
		readlink "$path"
	fi
}

check_opt_mod_dep_cmds() {
	local path=$1
	local -a DEP_CMDS
	# shellcheck disable=2207
	IFS=' ' DEP_CMDS=($(get_opt "$path" DEP_CMDS))

	local cmd
	for cmd in "${DEP_CMDS[@]}"; do
		if one_l.has_not command "$cmd"; then
			printf "%bThe command '%s' is required but not found in host.\nSee %s to install it.%b\n" \
				"$RED" "$cmd" "https://command-not-found.com/$cmd" "$RESET_ALL" >&2
			return 10
		fi
	done
}

print_list_item() {
	local repo_filter=${1:-}
	local line type mod_type mod_name repo_name priority

	declare -A MOD_TYPE_COLOR=(
		['completion']=$GREEN
		['plugin']=$BLUE
		['alias']=$PURPLE
		[bin]=$WHITE
		[sub]=$YELLOW
	)

	while read -r line; do
		read -r -a list < <(echo "${line##*/}" | sed -E "s/^([[:digit:]]{3})---([^@]+)@([^@]+)@([^@]+)\.bash\$/\1 \2 \3 \4/")
		priority="${list[0]}"
		mod_name=${list[1]}
		repo_name=${list[2]}
		type=${list[3]}

		local -a prints=()
		local format='' mod_real_path about=''

		mod_real_path="$(readlink "$line")"
		if [[ $mod_real_path == $ONE_DIR/data/$type/* ]]; then
			about="$(. "$(dirname "$mod_real_path")/meta.bash" && echo "$about")"
		elif [[ $mod_real_path =~ .+\/$repo_name\/$type\/ ]]; then
			# if mod_real_path matches ../(alias|plugin|completion)/..
			about=$(metafor about-plugin <"$mod_real_path")
		fi

		if [[ -n $repo_filter ]] && [[ $repo_filter != "$repo_name" ]]; then
			continue
		fi

		# load-priority
		format="$format%b%-4s"
		prints+=("$YELLOW" "$priority")

		# mod type
		format="$format %b%-4s"
		mod_type=${type^}
		prints+=("${MOD_TYPE_COLOR[${type}]}" "${mod_type:0:4}")

		# mod_name repo_name
		format="$format %b%-18s %b%-18s"

		prints+=(
			"$CYAN" "${mod_name:0:18}"
			"$BLUE" "${repo_name:0:18}"
		)

		# About
		format="$format %b%s"
		prints+=("$WHITE" "$about")

		# shellcheck disable=2059
		printf "$format\n" "${prints[@]}"
	done
}
