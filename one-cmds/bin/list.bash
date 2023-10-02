usage_list() {
  cat <<EOF
Usage: one bin list
Desc:  List executable filenames in each REPO/bin
EOF
}

list() {
  local path repo

  # shellcheck disable=2153
  for path in "${ONE_DIR}"/enabled/bin/*; do
    printf '%b%20s%b -> %b%s\n' \
      "$GREEN" "$(basename "$path")" "$GREY"\
      "$WHITE" "$(readlink "$path")"
  done
}

list_bin() {
  local path repo name link

  shopt -s nullglob

  for repo in "${ONE_DIR}"/enabled/repos/* ; do
    printf '%b[%s]%b\n' "$BLUE" "$repo" "$RESET_ALL"

    for path in "$repo/bins"/* ; do
      name=$(basename "$path" '.opt.bash')
      link=${ONE_DIR}/enabled/bin/$name

      if [[ -h "$link" ]] && [[ $(readlink "$link") == "$path" ]]; then
        printf '%b%s%b ' "$BOLD_GREEN" "$name" "$RESET_ALL"
      else
        printf '%s ' "$name"
      fi
    done
    printf '\n'
  done

  printf "\n### The %bGREEN%b items are enabled. The WHITE items are availabled. ###\n" "$BOLD_GREEN" "$RESET_ALL"
}
