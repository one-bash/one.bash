usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one dotbot-plugin add <URL>

Desc: Download dotbot plugin

Arguments:
  <URL>          Support http/https, git, local directory.
                 Local directory must be absolute path. one.bash will create a symlink to the directory.

Examples:
  one dotbot-plugin add DrDynamic/dotbot-git
  one dotbot-plugin add https://github.com/DrDynamic/dotbot-git
  one dotbot-plugin add https://github.com/DrDynamic/dotbot-git.git
  one dotbot-plugin add git@github.com:DrDynamic/dotbot-git.git
  one dotbot-plugin add /home/adoyle/any/folder
EOF
	# editorconfig-checker-enable
}

completion() {
	true
}

download() {
	local src=$1

	if [[ $NO_DOWNLOAD != false ]]; then
		return
	fi

	if [[ $src == *.git || $src == http?(s)://* ]]; then
		print_verb "[Dotbot:plugin:$name] to download via git"
		git -C "$ONE_DIR/data/dotbot-plugin/" clone --single-branch --progress "$src"
	elif [[ $src =~ ^[^/]+/[^/]+$ ]]; then
		print_verb "[Dotbot:plugin:$name] to download via git"
		git -C "$ONE_DIR/data/dotbot-plugin/" clone --single-branch --progress "https://github.com/$src.git"
	elif [[ $src == /* ]]; then
		src=${src%/}
		print_verb "[Dotbot:plugin:$name] to download via local path"
		ln -s "$src" "$ONE_DIR/data/dotbot-plugin/$name"
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

	if [[ -e "$ONE_DIR/data/dotbot-plugin/$name" ]]; then
		answer=$(l.ask "The dotbot-plugin '$name' has been downloaded. Re-download it?" N)
		if [[ $answer == YES ]]; then
			rm -rf "$ONE_DIR/data/dotbot-plugin/$name"
		else
			NO_DOWNLOAD=true
		fi
	fi

	download "$src"
}
