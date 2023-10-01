_one_is_completable() {
  grep -i '^# one.bash:completion' "$1" >/dev/null
}

# @param cmd_dir  command directory
# @param cmd  command name
_one_sub_cmd_completion() {
  local cmd_path="$1"
  if [[ ! -x "$cmd_path" ]]; then return 0; fi

  if _one_is_completable "$cmd_path"; then
    shift 1
    # shellcheck disable=2097,2098
    COMP_CWORD=$COMP_CWORD "$cmd_path" --complete "$@"
  fi
}

_one_COMP_REPLY() {
  local str

  if [[ -z "$word" ]]; then
    while read -r str; do
      COMPREPLY+=( "$str" )
    done
  else
    while read -r str; do
      if [[ $str =~ ^"$word" ]]; then
        COMPREPLY+=( "$str" )
      fi
    done
  fi
}

_comp_sub() {
  local word="${COMP_WORDS[COMP_CWORD]}"

  if (( COMP_CWORD == 1 )); then
      # Expend sub commands
      _one_COMP_REPLY < <("$ONE_DIR"/one-cmds/sub list)
    _one_COMP_REPLY <<< 'help'
  else
    # Expend options of sub command
    local cmd="${COMP_WORDS[1]}"
    local repo

    if [[ $cmd == help ]]; then
      _one_COMP_REPLY < <(_one_sub_cmd_completion "$ONE_DIR/one-cmds/help-sub" "${COMP_WORDS[@]:2}")
      return 0
    fi

    for repo in "${ONE_DIR}"/enabled/repos/*; do
      if [[ ! -d "$repo/sub" ]]; then continue; fi

      _one_COMP_REPLY < <(_one_sub_cmd_completion "$repo/sub/$cmd" "${COMP_WORDS[@]:2}")
    done
  fi
}

_comp_one() {
  local word="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=()

  if (( COMP_CWORD == 1 )); then
    # Expend one commands
    _one_COMP_REPLY < <("$ONE_DIR/one-cmds/commands")
    local words=(subs -h --help --bashrc)
    _one_COMP_REPLY < <(printf '%s\n' "${words[@]}")
  else
    local cmd="${COMP_WORDS[1]}"

    if [[ $cmd == subs ]]; then
      # Expend sub commands

      # Shift first item on COMP_WORDS
      local -a words
      local w
      # Because COMP_WORDS may contain empty argument ""
      for w in "${COMP_WORDS[@]:1}"; do
        words+=("$w")
      done
      COMP_WORDS=()
      for w in "${words[@]}"; do
        COMP_WORDS+=("$w")
      done

      COMP_CWORD=$(( COMP_CWORD - 1 ))
      _comp_sub
    else
      case $cmd in
        r) cmd=repo;;
        a) cmd='alias';;
        b) cmd=bin;;
        c) cmd=completion;;
        p) cmd=plugin;;
      esac

      if [[ -d "$ONE_DIR/one-cmds/$cmd" ]]; then
        # Expend options of one command
        _one_COMP_REPLY < <(_one_sub_cmd_completion "$ONE_DIR/one-cmds/$cmd/main" "${COMP_WORDS[@]:2}")
      else
        # Expend options of one command
        _one_COMP_REPLY < <(_one_sub_cmd_completion "$ONE_DIR/one-cmds/$cmd" "${COMP_WORDS[@]:2}")
      fi
    fi
  fi
}

complete -F _comp_one one

if [[ -n ${ONE_SUB:-} ]]; then
  # shellcheck disable=SC2139
  alias "$ONE_SUB"='one subs '  # NOTE: last space is import for _comp_sub
  complete -F _comp_sub "$ONE_SUB"
fi
