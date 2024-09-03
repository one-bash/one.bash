usage() {
  cat << EOF
Usage: one $t enable <NAME> [<NAME>...]
Desc:  Enable matched $ts
Arguments:
  <name>  $t name
EOF
}

completion() {
  declare -a plugin_dirs=()
  local repo

  # shellcheck disable=2153
  for repo in "${ONE_DIR}/enabled/repos"/*; do
    # shellcheck disable=2154
    if [[ -d "$repo/$ts" ]]; then
      plugin_dirs+=("$repo/$ts")
    fi
  done

  for dir in "${plugin_dirs[@]}"; do
    find -L "$dir" -maxdepth 1 -type f -name "*.bash" -exec basename {} ".bash" \; | sed -E 's/\.opt$//'
  done
}

main() {
  . "$ONE_DIR/one-cmds/mod.bash"
  if (($# == 0)); then usage; else enable_it "$@"; fi
}
