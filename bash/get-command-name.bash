_one_get_command_name() {
	local cmd=$1
	case $cmd in
		a) cmd='alias' ;;
		b) cmd=bin ;;
		c) cmd=completion ;;
		d) cmd=dep ;;
		r) cmd=repo ;;
		p) cmd=plugin ;;
		s) cmd=sub ;;
	esac
	echo "$cmd"
}
