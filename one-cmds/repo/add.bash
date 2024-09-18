usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo add <URL>

Desc: Download and enable a repo

Arguments:
  <URL>          Support http/https, git, local directory.
                 Local directory must be absolute path. one.bash will create a symlink to the directory.

Examples:
  one repo add one-bash/one.share
  one repo add https://github.com/one-bash/one.share
  one repo add https://github.com/one-bash/one.share.git
  one repo add /home/adoyle/any/folder
EOF
	# editorconfig-checker-enable
}

download() {
	local src=$1

	if [[ $NO_DOWNLOAD != false ]]; then
		return
	fi

	if [[ $src == *.git || $src == http?(s)://* ]]; then
		print_verb "[REPO: $name] to download via git"
		git -C "$ONE_DIR/data/repo/" clone --single-branch --progress "$src"
	elif [[ $src =~ ^[^/]+/[^/]+$ ]]; then
		print_verb "[REPO: $name] to download via git"
		git -C "$ONE_DIR/data/repo/" clone --single-branch --progress "https://github.com/$src.git"
	elif [[ $src == /* ]]; then
		src=${src%/}
		print_verb "[REPO: $name] to download via local path"
		ln -s "$src" "$ONE_DIR/data/repo/$name"
	else
		print_err "Invalid url: $src"
		return "$ONE_EX_USAGE"
	fi
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

	download "$src"

	(
		cd "$ONE_DIR/data/repo/$name" &>/dev/null || return 21
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
