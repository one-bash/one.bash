usage() {
  cat << EOF
Usage: one repo add <URL>

Desc: Add a repo and enable it

Arguments:
  <URL>          Support http, git, local directory.
                 Local directory must be absolute path. It will create a symlink to the directory.
EOF
}

get_repo_name() {
  local dir=$1
  local name

  if [[ ! -f "$dir/one.repo.bash" ]]; then
    print_err "'one.repo.bash' file not existed in directory: $dir"
    return "$ONE_EX_DATAERR"
  fi

  # shellcheck disable=1091
  name=$(. "$dir/one.repo.bash" && echo "${name:-}")
  if [[ -z $name ]]; then
    print_err "The repo name should not be empty in one.repo.bash"
    return "$ONE_EX_DATAERR"
  fi

  echo "$name"
}

main() {
  local src=$1
  local name

  . "$ONE_DIR/bash/repo.bash"

  case $src in
    http* | git*)
      git -C "$ONE_DIR/data/repos/" clone --single-branch --progress "$src"
      name=$(get_repo_name "$(basename "$src" .git)")
      ;;
    /*)
      # shellcheck disable=1091
      name=$(get_repo_name "$src")

      if [[ -e "$ONE_DIR/data/repos/$name" ]]; then
        print_err "Repo '$name' existed"
        return "$ONE_EX_USAGE"
      fi
      ln -s "$src" "$ONE_DIR/data/repos/$name"
      ;;
    *)
      print_err "Invalid url: $src"
      return "$ONE_EX_USAGE"
      ;;
  esac

  (
    cd "$ONE_DIR/data/repos/$name" || return 20
    # shellcheck disable=1090
    . "$ONE_DIR/data/repos/$name/one.repo.bash"
    if type -t repo_add_post > /dev/null; then
      print_verb "To execute repo_add_post()"
      repo_add_post
    fi
  )

  one repo enable "$name"
}
