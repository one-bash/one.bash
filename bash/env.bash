# Required variables which OS related for plugins should put in this file.

ONE_OS=$(one_l.detect_os)

case $ONE_OS in
	MacOS)
		# shellcheck source=./envs/macos.bash
		_one_load "bash/envs/macos.bash"
		;;
	Linux)
		# shellcheck source=./envs/linux.bash
		_one_load "bash/envs/linux.bash"
		;;
	*) ;;
esac
