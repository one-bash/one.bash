print_info_item() {
	local key=$1
	local val=$2

	[[ -z $val ]] && return

	printf "%b%-${PRINT_INFO_KEY_WIDTH:-10}s%b= " "$BLUE" "${key^}" "$RESET_ALL"

	if [[ $val =~ ^[0-9]+$ ]]; then
		printf '%b%s' "$YELLOW" "$val"
	else
		case ${val,,} in
			true | enabled)
				printf '%b%s' "$GREEN" "$val"
				;;
			false)
				printf '%b%s' "$RED" "$val"
				;;
			disabled)
				printf '%b%s' "$GREY" "$val"
				;;
			invalid)
				printf '%b%s' "$YELLOW" "$val"
				;;
			*)
				printf '%s' "$val"
				;;
		esac
	fi

	printf '%b\n' "$RESET_ALL"
}

metafor() {
	local keyword=$1
	# Copy from composure.sh
	# grep keyword # strip trailing '|"|; # ignore thru keyword and leading '|"
	sed -n "/$keyword / s/['\";]*\$//;s/^[ 	]*\(: _\)*$keyword ['\"]*\([^([].*\)*\$/\2/p"
}
