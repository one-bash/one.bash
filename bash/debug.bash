# You can invoke "a debug true" to set ONE_DEBUG=true. And "a debug false" to unset.
if [[ $ONE_DEBUG == true ]]; then
  one_debug() {
    local ts fmt tag

    ts=$(date +"%H:%M:%S")

    if (($# > 1)); then
      fmt="${GREY}[one.bash|%s]${RESET_ALL} $1\n"
      shift 1
    else
      fmt="${GREY}[one.bash|%s]${RESET_ALL} %s\n"
    fi

    tag="$ts|$(basename "${BASH_SOURCE[1]}")"

    # shellcheck disable=SC2059
    printf "$fmt" "$tag" "$@" > /dev/tty

    return 0
  }
else
  one_debug() { return 0; }
fi
