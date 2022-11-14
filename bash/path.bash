export PATH=''  # reset PATH

for path in "${ONE_PATHS[@]}"; do
  if [[ $path == ONE_REPO_BINS ]]; then
    # shellcheck disable=2153
    for ONE_REPO in "${ONE_REPOS[@]}"; do
      if [[ -d "$ONE_REPO/bin" ]]; then
        PATH=${PATH}:"$ONE_REPO/bin"
      fi
    done
  elif [[ -d $path ]]; then
    PATH=${PATH}:$path
  fi
done

PATH="${PATH:1}" # remove first colon

unset -v path ONE_REPO
