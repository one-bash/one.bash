usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t which [OPTIONS] <NAME>
Desc:  Show realpath of $t
Arguments:
  <NAME>    the $t name
Options:
  -r, --repo <repo>       repo name
EOF
	# editorconfig-checker-enable
}

completion() {
	((COMP_CWORD > 1)) && return
	# shellcheck source=../mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"
	list_mod
}

main() {
	. "$ONE_DIR/one-cmds/mod.bash"
	if (($# == 0)); then usage; else search_it "$1"; fi
}
