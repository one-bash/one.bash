usage() {
  cat <<EOF
Usage:  one repo [-h|--help] <ACTION>
        one repo [-h|--help]

Desc:   Manage one.bash repos

ACTION:
  l, list          List available repos
  a, add           Add a repo and enable it
  r, remove        Remove a repo
  u, update        Update a repo
  e, enable        Enable a repo
  d, disable       Disable a repo
  i, info          Show the information of repo
  init [<PATH>]    Scaffolding a repo in <PATH> (Defaults to \$PWD)
EOF
}
