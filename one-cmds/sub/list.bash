usage() {
  cat << EOF
Usage: one sub list
Desc:  List sub commands in each REPO/sub
EOF
}

list() {
  local path repo

  # shellcheck disable=2153
  for path in "${ONE_DIR}"/enabled/sub/*; do
    printf '%b%20s%b -> %b%s\n' \
      "$GREEN" "$(basename "$path")" "$GREY" \
      "$WHITE" "$(readlink "$path")"
  done
}

main() {
  shopt -s nullglob
  local path repo name link repo_name

  for repo in "${ONE_DIR}"/enabled/repos/*; do
    repo_name=$(basename "$repo")
    printf '%b[%s]%b' "$BLUE" "$repo_name" "$RESET_ALL"

    for path in "$repo"/sub/*; do
      name=$(basename "$path" '.bash')
      name="${name%.sh}"
      link=${ONE_DIR}/enabled/sub/$name

      if [[ -L "$link" ]] && [[ $(readlink "$link") == "$path" ]]; then
        printf ' %b%s%b' "$BOLD_GREEN" "$name" "$RESET_ALL"
      else
        printf ' %s' "$name"
      fi
    done
    printf '\n'
  done

  printf "\n### The %bGREEN%b items are enabled. The WHITE items are available. ###\n" "$BOLD_GREEN" "$RESET_ALL"
}
