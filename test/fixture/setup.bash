# bats not open errexit, nounset and pipefail by default
set -o errexit
# set -o nounset
set -o pipefail
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

if [[ -n ${DOCKER:-} ]]; then
  load /test/support/load.bash
  load /test/assert/load.bash
else
  load "$TEST_DIR"/fixture/support/load.bash
  load "$TEST_DIR"/fixture/assert/load.bash
fi

load_fixtrue() {
  local path=$1;
  shift
  load "$TEST_DIR/fixtrue/$path.bash" "$@"
}

load_module() {
  [[ $# != 1 ]] && echo "load_module must have one argument at least." >&2 && return 3
}

# Fix: bats-core reset "set -e"
# https://github.com/bats-core/bats-core/blob/master/libexec/bats-core/bats-exec-test#L60
run() {
  local origFlags="$-"
  local origIFS="$IFS"
  set +eET
  # bats has bug, /lobash/tests/fixture/bats/libexec/bats-core/bats-exec-test: line 7: BASH_SOURCE: unbound variable
  output="$(set -o nounset; set -e; "$@" 2>&1)"
  status="$?"
  IFS=$'\n' lines=($output)
  IFS="$origIFS"
  set "-$origFlags"
}
