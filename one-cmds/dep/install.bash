usage() {
  cat << EOF
Usage: one dep install
Desc:  Install all deps.
EOF
}

completion() {
  words=(composure dotbot)
  printf '%s\n' "${words[@]}"
}

git_clone() {
  local repo=$1
  local dir=$2
  if [[ -d "$dir" ]]; then return 0; fi
  shift 2

  if [[ -z ${SUBMOD:-} ]]; then
    git clone --depth 1 --single-branch "$@" "$repo" "$dir"
  else
    git clone --depth 1 --single-branch --recurse-submodules --shallow-submodules "$@" "$repo" "$dir"
  fi
}

main() {
  SUBMOD=true git_clone "https://github.com/anishathalye/dotbot.git" "$ONE_DIR/deps/dotbot"
  git_clone "https://github.com/adoyle-h/composure.git" "$ONE_DIR/deps/composure"
}
