complete_update() {
  local path
  for path in "$ONE_DIR/data/repos/${@: -1}"*; do
    if [[ -d $path ]] && [[ -f $path/one.repo.bash ]]; then
      # shellcheck disable=1091
      . "$path/one.repo.bash"
      echo "${name:-}"
    fi
  done
}

update_repo() {
  local name=$1
  local repo_dir=$ONE_DIR/data/repos/$name

  if [[ ! -d "$repo_dir/.git" ]]; then
    print_error "The repo is not a git project"
    return 4
  fi

  print_verb "[TODO] git -C $repo_dir pull"
  git -C "$repo_dir" pull

  (
    cd "$repo_dir" || return 20
    # shellcheck disable=1091
    . "$repo_dir/one.repo.bash"
    if type -t repo_update >/dev/null; then repo_update; fi
  )

  print_success "Updated repo: $name"
}
