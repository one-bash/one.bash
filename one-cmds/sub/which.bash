usage() {
  cat << EOF
Usage: one sub which <NAME>
Desc:  Show realpath of sub command
Arguments:
  <NAME>      Sub name
EOF
}

completion() {
  # shellcheck source=../../bash/load-config.bash
  . "$ONE_DIR/bash/load-config.bash"
  one sub list
}

main() {
  local name=$1
  local path

  shopt -s nullglob
  for path in "$ONE_DIR"/enabled/repos/*/sub/"$name"; do
    if [[ -x $path ]]; then
      echo "$path"
    fi
  done
}
