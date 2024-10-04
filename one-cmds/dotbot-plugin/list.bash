usage() {
	cat <<EOF
Usage: one dotbot-plugin list
Desc:  List downloaded dotbot plugins
EOF
}

main() {
	local dirpath name URL=''

	printf '%-20s%b%s\n' "Name" "$RESET_ALL" "URL"

	shopt -s nullglob
	for dirpath in "$ONE_DIR"/data/dotbot-plugin/*; do
		if [[ ! -d $dirpath ]]; then continue; fi
		name="${dirpath##*/}"

		URL=$(git -C "$dirpath" remote get-url origin)

		printf '%b%-20s%b%s\n' "$BLUE" "$name" "$RESET_ALL" "$URL"
	done
}
