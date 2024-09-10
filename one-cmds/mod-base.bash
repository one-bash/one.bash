print_info_item() {
	local key=$1
	local val=$2

	[[ -z $val ]] && return

	printf "%b%-${PRINT_INFO_KEY_WIDTH:-10}s%b= " "$BLUE" "$key" "$RESET_ALL"

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

	printf '%b\n' "$RESET_ALL"
}

metafor() {
	local keyword=$1
	# Copy from composure.sh
	sed -n "/$keyword / s/['\";]*\$//;s/^[      ]*\(: _\)*$keyword ['\"]*\([^([].*\)*\$/\2/p"
}
