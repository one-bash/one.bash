usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo init [<PATH>]

Desc: Scaffolding a repo in <PATH> (Defaults to \$PWD)

Arguments:
  <PATH>        Relative or absolute filepath. If not passed, use current directory
EOF
	# editorconfig-checker-enable
}

completion() {
	if (($# > 1)); then return; fi
	compgen -f -- "${1:-}"
}

is_empty_dir() {
	[[ -z $(ls -A "${1:-}") ]]
}

create_one_links_yaml() {
	# editorconfig-checker-disable
	cat <<EOF >one.links.yaml
# It is just an example. All belows are unnecessary.
- defaults:
    link:
      relink: true   # If true, override the target file when it existed
      create: true
      glob: true

# NOTE: dotbot have no sudo permission
- shell: []

- link: []
EOF
	# editorconfig-checker-enable
}

main() {
	local repo_dir=${1:-$PWD}
	local repo_name answer

	mkdir -p "$repo_dir"
	cd "$repo_dir" || return 20

	repo_name="${repo_dir##*/}"

	if [[ -f one.repo.bash ]]; then
		answer=$(l.ask "The file 'one.repo.bash' existed. Override it?")
		if [[ $answer == YES ]]; then
			echo "name=$repo_name" >one.repo.bash
		fi
	else
		echo "name=$repo_name" >one.repo.bash
	fi

	mkdir -p alias bin config completion plugin sub

	if [[ -f README.md ]]; then
		answer=$(l.ask "The file 'README.md' existed. Override it?" N)
		if [[ $answer == YES ]]; then
			cat <<EOF >README.md
# ONE REPO

A repo for [one.bash](https://github.com/one-bash/one.bash).
EOF
		fi
	else
		cat <<EOF >README.md
# ONE REPO

A repo for [one.bash](https://github.com/one-bash/one.bash).
EOF
	fi

	if [[ -f one.links.yaml ]]; then
		answer=$(l.ask "The file 'one.links.yaml' existed. Override it?" N)
		if [[ $answer == YES ]]; then
			create_one_links_yaml
		fi
	else
		create_one_links_yaml
	fi

	cd - &>/dev/null || return 21
	print_success "Created repo: $repo_dir"
}
