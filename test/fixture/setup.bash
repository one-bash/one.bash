# bats not open errexit, nounset and pipefail by default
set -o errexit -o pipefail
# set -o nounset
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

if [[ -n ${DOCKER:-} ]]; then
	load /test/support/load.bash
	load /test/assert/load.bash
	load /test/bats-file/load.bash
else
	load "$TEST_DIR"/fixture/support/load.bash
	load "$TEST_DIR"/fixture/assert/load.bash
	load "$TEST_DIR"/fixture/bats-file/load.bash
fi

load_fixtrue() {
	local path=$1
	shift
	load "$TEST_DIR/fixtrue/$path.bash" "$@"
}

# Fix: bats-core reset "set -e"
# https://github.com/bats-core/bats-core/blob/master/libexec/bats-core/bats-exec-test#L60
run() {
	local origFlags="$-"
	local origIFS="$IFS"
	set +eET
	# bats has bug, /lobash/tests/fixture/bats/libexec/bats-core/bats-exec-test: line 7: BASH_SOURCE: unbound variable
	output="$(
		set -o nounset
		set -e
		"$@" 2>&1
	)"
	status="$?"
	IFS=$'\n' lines=($output)
	IFS="$origIFS"
	set "-$origFlags"
}

# To fix run --separate-stderr
bats_require_minimum_version 1.5.0

# add bin/one to PATH
PATH="$ROOT_DIR/bin:$PATH"
