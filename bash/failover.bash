# You can invoke "a fast-bashrc open" to set .fast_bashrc. And "a fast-bashrc close" to unset.
export ONE_BASHRC_FO

one_failover() {
  if [[ -r "$ONE_BASHRC_FO" ]]; then
    printf '%b%s%b\n' "$YELLOW" "[one.bash] Now switch to failover mode." "$RESET_ALL"
    one_debug "To enter ONE_BASHRC_FO: ${ONE_BASHRC_FO}"

    # shellcheck source=./bashrc.failover.bash
    source "$ONE_BASHRC_FO"
  fi
  return 0
}

check_shell() {
  if [[ $ONE_LOADED == failed ]]; then
    return "$ONE_EX_SOFTWARE"
  fi

  if [[ ${BASH_VERSINFO[0]} -lt 4 ]] ||
    { [[ ${BASH_VERSINFO[0]} == 4 ]] && [[ ${BASH_VERSINFO[1]} -lt 4 ]]; } \
    ; then
    cat >&2 << EOF
${YELLOW_ESC}
[one.bash] Current Bash version ($BASH_VERSION) is not supported.
Please upgrade Bash to 4.4 or higher version, and then restart shell to continue.

For mac user, \`brew install bash\` to install latest version.
${RESET_ALL_ESC}
EOF
    return 3
  fi

  # shellcheck disable=2016
  if [[ $(/usr/bin/env bash -c 'echo "$BASH_VERSION"') != "$BASH_VERSION" ]]; then
    cat >&2 << EOF
${YELLOW_ESC}
[one.bash] Please check PATH environment variable. The bash is different from your current shell.
You can invoke "\$(/usr/bin/env bash -c 'echo \"\$BASH_VERSION\"')" and "\`which bash\` --version" to check version.
Please fix your PATH, and then restart shell to continue.
${RESET_ALL_ESC}
EOF
    return 4
  fi
}
