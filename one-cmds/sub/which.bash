usage_which() {
  cat <<EOF
Usage: one sub which <cmd>
Desc:  Show filepath of <cmd>
EOF
}

complete_which() {
  # shellcheck source=../../bash/load-config.bash
  . "$ONE_DIR/bash/load-config.bash"
  one sub list
}

which_sub() {
  local name=$1
  local path

  for path in "$ONE_DIR"/enabled/repos/*/sub/"$name"; do
    if [[ -x $path ]]; then
      echo "$path"
    fi
  done
}
