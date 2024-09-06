usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t list [<OPTIONS>]
Desc: List enabled $ts
Options:
  -a, --all           list all available $ts in each repo
  -n                  list module names instead of filepaths
EOF
	# editorconfig-checker-enable
}

completion() {
	((COMP_CWORD > 1)) && return
	printf -- '--all\n-n\n--help\n'
}

main() {
	. "$ONE_DIR/one-cmds/mod.bash"
	list_mods
}
