# To execute `repo_load` function if it defined in `one.repo.bash` of each repo.
_one_load_repos() {
  local CUR_REPO_DIR func_str

  for CUR_REPO_DIR in "$ONE_DIR"/enabled/repos/*; do
    if [[ ! -f $CUR_REPO_DIR/one.repo.bash ]]; then continue; fi

    # shellcheck disable=1091
    func_str=$( . "$CUR_REPO_DIR"/one.repo.bash && { declare -f repo_load || true; } )
    if [[ -n $func_str ]]; then
      eval "$func_str"
      repo_load
      unset -f repo_load
      func_str=''
    fi
  done
}
_one_load_repos
unset -f _one_load_repos
