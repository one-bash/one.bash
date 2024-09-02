usage_disable() {
  cat <<EOF
Usage: one bin disable [-a|--all] <NAME>...
Desc:  Disable matched bin files
Arguments:
  <name>       bin name
Options:
  -a, --all    Disable all bin files
EOF
}

complete_disable() {
  shopt -s nullglob
  local path

  for path in "$ONE_DIR/enabled/bin/${@: -1}"*; do
    if [[ -h $path ]]; then
      basename "$path"
    fi
  done
}

disable_it() {
  local name=$1
  local path="${2:-$ONE_DIR/enabled/bin/$name}"
  local src

  if [[ -h $path ]]; then
    src=$(readlink "$path")
    unlink "$path"
    printf "Disabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$src"
  else
    print_err "No matched file '$name'"
    return 4
  fi
}

disable_bin() {
  local name path

  if [[ ${1:-} == -a ]] || [[ ${1:-} == --all ]]; then
    for path in "${ONE_DIR}"/enabled/bin/*; do
      name=$(basename "$path")
      disable_it "$name" "$path" || true
    done
  else
    for name in "$@"; do
      disable_it "$name" || true
    done
  fi
}
