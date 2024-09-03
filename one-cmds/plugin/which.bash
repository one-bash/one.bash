usage() {
  cat << EOF
Usage: one $t which <NAME>
Desc:  Show realpath of $t
Arguments:
  <NAME>    the $t name
EOF
}

completion() {
  ((COMP_CWORD > 3)) && return
  # shellcheck source=../mod.bash
  . "$ONE_DIR/one-cmds/mod.bash"
  list_mod
}

main() {
  . "$ONE_DIR/one-cmds/mod.bash"
  if (($# == 0)); then usage; else search_it "$1"; fi
}
