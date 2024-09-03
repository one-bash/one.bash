usage() {
  cat << EOF
Usage: one $t disable [-a|--all] <NAME>...
Desc:  Disable matched $ts
Arguments:
  <name>       $t name
Options:
  -a, --all    Disable all $ts
EOF
}

completion() {
  echo '--all'

  # shellcheck disable=2154
  find "$ENABLED_DIR" -maxdepth 1 -name "*---*.$t.bash" -print0 |
    xargs -0 -I{} basename '{}' ".$t.bash" |
    sed -E 's/^[[:digit:]]{3}---(.+)$/\1/' || true
}

main() {
  . "$ONE_DIR/one-cmds/mod.bash"
  if (($# == 0)); then usage; else disable_it "$@"; fi
}
