usage() {
  cat << EOF
Usage:  one bin [-h|--help] <ACTION>
        one bin [-h|--help]

Desc:   Manage executable files in ONE_REPO/bins/

ACTION:
  e, enable           Enable matched bin
  d, disable          Disable matched bin
  l, list             List executable filenames in each REPO/bin
  i, info             Show info of matched bin
EOF
}
