usage() {
  cat << EOF
Usage: one repo info <NAME>
Desc:  Show the informations of repo
EOF
}

completion() {
  shopt -s nullglob
  local path
  for path in "$ONE_DIR/data/repos/${@: -1}"*; do
    if [[ -d $path ]] && [[ -f $path/one.repo.bash ]]; then
      # shellcheck disable=1091
      . "$path/one.repo.bash"
      echo "${name:-}"
    fi
  done
}

search_repos() {
  local repo_name=$1
  grep -l -E "name=['\"]?${repo_name}['\"]?" "$ONE_DIR"/data/repos/*/one.repo.bash
}

main() {
  local repo_name=${1:-}
  local repo_path path

  if [[ -z $repo_name ]]; then
    usage_info
    return 0
  fi

  while read -r path; do
    repo_path=$(dirname "$path")
    print_info_item name "$repo_name"
    print_info_item path "$repo_path"

    (
      # shellcheck disable=1090
      . "$path"
      declare -f repo_add_post || true
      declare -f repo_update || true
      declare -f repo_onload || true
    )
  done < <(search_repos "$1")

  if [[ -z "${repo_path:-}" ]]; then
    print_err "No matched repo '$repo_name'"
    return 2
  fi
}
