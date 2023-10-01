complete_disable() {
  local path
  for path in "$ONE_DIR/enabled/repos/${1:-}"*; do
    if [[ -d $path ]]; then
      basename "$path"
    fi
  done
}

disable_repo() {
  local name=$1
  local filepath="$ONE_DIR/enabled/repos/$name"

  if [[ -h $filepath ]]; then
    unlink "$filepath"
    print_success "Disabled repo: $name"
  else
    print_error "Not found repo: $name"
    return 2
  fi
}
