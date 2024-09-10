# To execute `repo_onload` function if it defined in `one.repo.bash` of each repo.
_one_load_repos() {
	local CUR_REPO_DIR func_str

	shopt -s nullglob
	for CUR_REPO_DIR in "$ONE_DIR"/enabled/repo/*; do
		if [[ ! -f $CUR_REPO_DIR/one.repo.bash ]]; then continue; fi

		# shellcheck disable=1091
		func_str=$(. "$CUR_REPO_DIR"/one.repo.bash && { declare -f repo_onload || true; })
		if [[ -n $func_str ]]; then
			eval "$func_str"
			repo_onload
			unset -f repo_onload
			func_str=''
		fi
	done
}
_one_load_repos
unset -f _one_load_repos
