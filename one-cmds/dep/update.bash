usage() {
  cat << EOF
Usage: one dep update [<DEP>]
Desc:  Update dep. If <DEP> is omit, update all deps.
Arguments:
  <DEP>    dependency name
EOF
}

completion() {
  words=(composure dotbot)
  printf '%s\n' "${words[@]}"
}

git_update() {
  local dir=$1 tag
  shift

  if [[ ! -d "$dir" ]]; then
    print_err "No such folder: $dir"
    return "$ONE_EX_OK"
  fi

  print_verb "To update git repo: $dir"

  git -C "$dir" fetch --recurse-submodules="${SUBMOD:-no}" "$@"
  tag=$(git -C "$dir" tag -l 'v*' --sort '-version:refname' | head -n 1)
  git -C "$dir" checkout --recurse-submodules="${SUBMOD:-no}" "$tag"
}

main() {
  if (($# == 0)); then
    SUBMOD=true git_update "$ONE_DIR/deps/dotbot"
    git_update "$ONE_DIR/deps/composure"
  else
    if [[ "$1" == dotbot ]] || [[ "$1" == one.share ]]; then
      SUBMOD=yes git_update "$ONE_DIR/deps/$1"
    else
      git_update "$ONE_DIR/deps/$1"
    fi
  fi
}
