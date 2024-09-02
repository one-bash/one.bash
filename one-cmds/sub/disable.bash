usage_disable() {
  cat << EOF
Usage: one sub disable [-a|--all] <NAME>...
Desc:  Disable sub command
Arguments:
  <name>  sub name
Options:
  -a, --all   Disable all sub commands
EOF
}

complete_disable() {
  shopt -s nullglob
  local path

  for path in "$ONE_DIR/enabled/sub/${@: -1}"*; do
    if [[ -L $path ]]; then
      basename "$path"
    fi
  done
}

disable_it() {
  local name=$1
  local path="$ONE_DIR/enabled/sub/$name"
  if [[ -L $path ]]; then
    unlink "$path"
    printf "Disabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
  else
    print_err "No matched file '$name'"
    return 4
  fi
}

disable_sub() {
  local name path

  if [[ ${1:-} == --all ]]; then
    for path in "${ONE_DIR}"/enabled/sub/*; do
      if [[ -L $path ]]; then
        unlink "$path"
        name=$(basename "$path")
        printf "Disabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
      fi
    done
  else
    for name in "$@"; do
      disable_it "$name" || true
    done
  fi
}
