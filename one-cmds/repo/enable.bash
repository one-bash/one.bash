complete_enable() {
  local path
  for path in "$ONE_DIR/data/repos/${1:-}"*; do
    if [[ -d $path ]] && [[ -f $path/one.repo.bash ]]; then
      # shellcheck disable=1091
      . "$path/one.repo.bash"
      echo "${name:-}"
    fi
  done
}

enable_repo() {
  local name=$1

  if [[ ! -e "$ONE_DIR/enabled/repos/$name" ]]; then
    ln -s "$ONE_DIR/data/repos/$name" "$ONE_DIR/enabled/repos/$name"
  fi

  print_success "Enabled repo: $name"
}
