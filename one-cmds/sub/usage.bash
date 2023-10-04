usage() {
  cat <<EOF
Usage:  one sub [-h|--help] <ACTION>
        one sub [-h|--help]

Desc:  Manage ONE_SUB commands

ACTION:
  e, enable           Enable matched executable files
  d, disable          Disable matched executable files
  l, list             List executable files in each REPO/sub
  i, info             Show info of matched executable files
  w, which <NAME>     Show realpath of executable files
EOF
}
