usage() {
  cat << EOF
Usage:  one $t <ACTION>
        one $t [-h|--help]
        one $t <-h|--help> <ACTION>

Desc:   Manage $ts in ONE_REPO/$ts/

Action:
  e, enable <NAME>...            Enable matched $ts
  d, disable <NAME>...           Disable matched $ts
  l, list                        List enabled $ts
  i, info <NAME>                 Show info of matched $ts
  w, which <NAME>                Show realpath of $t
  edit <NAME>                    Edit matched $ts
EOF
  exit 0
}
