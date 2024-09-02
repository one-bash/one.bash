usage_init() {
  cat << EOF
Usage: one repo init [<PATH>]

Desc: Scaffolding a repo in <PATH> (Defaults to \$PWD)

Arguments:
  <PATH>  If <PATH> not passed, use current directory
EOF
}

complete_init() {
  if (($# > 1)); then return; fi
  compgen -f -- "${1:-}"
}

is_empty_dir() {
  [[ -z $(ls -A "${1:-}") ]]
}

init_repo() {
  local repo_dir=${1:-$PWD}
  local repo_name answer

  if ! is_empty_dir "$repo_dir"; then
    echo "Directory '$repo_dir' is not empty" >&2
    return 1
  fi

  mkdir -p "$repo_dir"
  cd "$repo_dir" || return 20

  repo_name=$(basename "$repo_dir")
  echo "name=$repo_name" > one.repo.bash

  answer=$(l.ask "To create folders (aliases bin completions configs plugins sub)?")

  if [[ $answer == YES ]]; then
    mkdir aliases bin completions configs plugins sub
  fi

  cat << EOF > README.md
# ONE REPO

A repo for [one.bash](https://github.com/one-bash/one.bash).
EOF

  cat << EOF > one.links.example.yaml
# It is just an example. All belows are unnecessary.
- defaults:
    link:
      # relink: true # If true, override the target file when it existed
      create: true

# NOTE: dotbot have no sudo permission
- shell: []

- link: []
EOF

  cd - > /dev/null || return 21
  print_success "Created repo: $repo_dir"
}
