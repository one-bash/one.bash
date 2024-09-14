export PATH='' # reset PATH

for path in "${ONE_PATHS[@]}"; do
	PATH=${PATH}:$path
done

PATH="${PATH:1}" # remove first colon

unset -v path
