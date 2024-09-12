usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo add <URL>

Desc: Download and enable a repo

Arguments:
  <URL>          Support http, git, local directory.
                 Local directory must be absolute path. one.bash will create a symlink to the directory.
EOF
	# editorconfig-checker-enable
}

download() {
	case $src in
		http://* | https://* | *.git)
			if [[ $NO_DOWNLOAD == false ]]; then
				print_verb "[REPO: $name] to download via git"
				git -C "$ONE_DIR/data/repo/" clone --single-branch --progress "$src"
			fi
			;;

		/*)
			if [[ $NO_DOWNLOAD == false ]]; then
				print_verb "[REPO: $name] to download via local path"
				ln -s "$src" "$ONE_DIR/data/repo/$name"
			fi
			;;

		*)
			print_err "Invalid url: $src"
			return "$ONE_EX_USAGE"
			;;
	esac

}

main() {
	local src=$1
	local name="${src##*/}"
	name=${name%.git}
	local NO_DOWNLOAD=false
	local repo_file=$ONE_DIR/data/repo/$name/one.repo.bash

	if [[ -e "$ONE_DIR/data/repo/$name" ]]; then
		answer=$(l.ask "The repo '$name' has been downloaded. Re-download it?" N)
		if [[ $answer == YES ]]; then
			rm -rf "$ONE_DIR/data/repo/$name"
		else
			NO_DOWNLOAD=true
		fi
	fi

	(
		cd "$ONE_DIR/data/repo/$name" || return 20
		# shellcheck disable=1090
		if [[ -f $repo_file ]]; then source "$repo_file"; fi

		if type -t repo_add_pre &>/dev/null; then
			print_verb "[REPO: $name] To execute repo_add_pre()"
			repo_add_post
			print_verb "[REPO: $name] repo_add_pre() success done"
		fi
	)

	download

	(
		cd "$ONE_DIR/data/repo/$name" || return 20
		# shellcheck disable=1090
		if [[ -f $repo_file ]]; then source "$repo_file"; fi

		if type -t repo_add_post &>/dev/null; then
			print_verb "[REPO: $name] To execute repo_add_post()"
			repo_add_post
			print_verb "[REPO: $name] repo_add_post() success done"
		fi
	)

	one repo enable "$name"
}
