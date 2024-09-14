with_pager() {
	local fn=$1
	local pager=${opts[pager]:-}
	if [[ $pager == false ]]; then
		$fn
	elif [[ -n $pager ]] && l.has command "$pager"; then
		$fn | $pager
	elif l.has command fzf; then
		$fn | fzf
	elif l.has command less; then
		$fn | less
	else
		$fn
	fi
}
