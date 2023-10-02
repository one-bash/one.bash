usage_disable() {
  cat <<EOF
Usage: one bin disable <NAME>...
Desc:  Disable matched bin files
Arguments:
  <name>  bin name
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
  local path="$ONE_DIR/enabled/bin/$name"
  if [[ -h $path ]]; then
    unlink "$path"
    printf "Disabled bin: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
  else
    print_error "No matched bin '$name'"
    return 4
  fi
}

disable_bin() {
  local name path

  if [[ ${1:-} == --all ]]; then
    for path in "${ONE_DIR}"/enabled/bin/*; do
      if [[ -h $path ]]; then
        unlink "$path"
        name=$(basename "$path")
        printf "Disabled bin: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
      fi
    done
  else
    for name in "$@"; do
      disable_it "$name" || true
    done
  fi
}
