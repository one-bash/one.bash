usage_info() {
  cat <<EOF
Usage: one repo info
Desc:  Show the informations of repo
EOF
}

complete_info() {
  local path
  for path in "$ONE_DIR/data/repos/${1:-}"*; do
    if [[ -d $path ]] && [[ -f $path/one.repo.bash ]]; then
      # shellcheck disable=1091
      . "$path/one.repo.bash"
      echo "${name:-}"
    fi
  done
}

info_repo() {
  local r=$1
  local repo=$ONE_DIR/data/repos/$r

  echo "repo_dir=$repo"

  if [[ -f "$repo/one.repo.bash" ]]; then
    (
      # shellcheck disable=1091
      . "$repo/one.repo.bash"
      echo "name=$name"
      declare -f repo_add_post || true
      declare -f repo_update || true
      declare -f repo_load || true
    )
  fi
}
