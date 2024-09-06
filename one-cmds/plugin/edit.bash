usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t edit <NAME>
Desc:  Edit matched $ts
Arguments:
  <NAME>    the $t name
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
	if (($# == 0)); then usage; else edit_mod "$1"; fi
}
