usage() {
  cat << EOF
Usage: one $(basename "$0") [<ACTION>]

Desc: Manage one.bash deps

ACTION:
  i, install          Install all deps.
  u, update [<DEP>]   Update dep. If <DEP> is omit, update all deps.
  s, status [<DEP>]   Show status of each dep. If <DEP> is omit, show all deps' status.
EOF
}
