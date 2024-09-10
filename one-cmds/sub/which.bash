usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one sub which <NAME>
Desc:  Show realpath of sub command
Arguments:
  <NAME>      Sub name
EOF
	# editorconfig-checker-enable
}

completion() {
	if (($# > 1)); then return 0; fi

	shopt -s nullglob
	for path in "${ONE_DIR}"/enabled/repo/*/sub/"${@: -1}"*; do
		name=${path##*/}
		echo "${name%.opt.bash}"
	done
}

main() {
	local name=$1
	local path

	shopt -s nullglob
	for path in "$ONE_DIR"/enabled/repo/*/sub/"$name"; do
		if [[ -x $path ]]; then
			echo "$path"
		fi
	done
}
