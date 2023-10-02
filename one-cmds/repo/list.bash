usage_list() {
  cat <<EOF
Usage: one repo list
Desc:  List available repos
EOF
}

list_repo() {
  shopt -s nullglob
  local repo name repo_status

  for repo in "$ONE_DIR"/data/repos/*; do
    if [[ ! -d "$repo" ]]; then continue; fi
    name=''

    if [[ -f "$repo/one.repo.bash" ]]; then
      # shellcheck disable=1091
      name=$( . "$repo/one.repo.bash" && echo "${name:-}" )
    fi

    if [[ -n $name ]]; then
      name_str=$(printf '%b%s' "$BLUE" "$name")

      if [[ -e "$ONE_DIR/enabled/repos/$name" ]]; then
        repo_status=$(printf '%bEnabled ' "$GREEN")
      else
        repo_status=$(printf '%bDisabled' "$GREY")
      fi
    else
      name_str=$(printf '%b%s' "$GREY" "<unknown>")
      repo_status=$(printf '%bInvalid ' "$YELLOW")
    fi

    printf '%s %-20s\t%b%s\n' "$repo_status" "$name_str"  "$RESET_ALL" "$repo"
  done
}
