# This file is generated by https://github.com/adoyle-h/lobash
# Command: lobash-gen -c ../one_l.conf one_l.bash
# Author: ADoyle <adoyle.h@gmail.com>
# License: Apache License Version 2.0
# Version: 0.7.0 (7ac03387f41cb7e5792c11ff06d8d58d9ac285b0)
# Prefix: one_l.
# Bash Minimum Version: 4.4
# UNIQ_KEY: 0_7_0_164825828_12785
# Included Modules: array_include has has_not is_array var_attrs is_function start_with str_include ask join str_replace trim trim_start trim_end detect_os

######################## Lobash Internals ########################

_lobash.0_7_0_164825828_12785_detect_os() {
  local kernel_name
  kernel_name="$(uname -s)"

  case "$kernel_name" in
    "Darwin")                         echo MacOS ;;
    "SunOS")                          echo Solaris ;;
    "Haiku")                          echo Haiku ;;
    "MINIX")                          echo MINIX ;;
    "AIX")                            echo AIX ;;
    "IRIX"*)                          echo IRIX ;;
    "FreeMiNT")                       echo FreeMiNT ;;
    "Linux" | "GNU"*)                 echo Linux ;;
    *"BSD" | "DragonFly" | "Bitrig")  echo BSD ;;
    "CYGWIN"* | "MSYS"* | "MINGW"*)   echo Windows ;;
    *)                                echo Unknown_OS "$kernel_name" ;;
  esac
}



[[ -n ${_LOBASH_0_7_0_164825828_12785_INTERNAL_FUNC_PREFIX:-} ]] && return

readonly _LOBASH_0_7_0_164825828_12785_INTERNAL_FUNC_PREFIX=_lobash.
readonly _LOBASH_0_7_0_164825828_12785_INTERNAL_CONST_PREFIX=_LOBASH_
readonly _LOBASH_0_7_0_164825828_12785_PRIVATE_FUNC_PREFIX=_l.
readonly _LOBASH_0_7_0_164825828_12785_PRIVATE_CONST_PREFIX=_L_
readonly _LOBASH_0_7_0_164825828_12785_PUBLIC_FUNC_PREFIX=one_l.
readonly _LOBASH_0_7_0_164825828_12785_PUBLIC_CONST_PREFIX=ONE_L_

readonly _LOBASH_0_7_0_164825828_12785_PREFIX=one_l.
_LOBASH_0_7_0_164825828_12785_PUBLIC_DEPTH=1  # NOTE: _LOBASH_0_7_0_164825828_12785_PUBLIC_DEPTH should not be readonly
readonly _LOBASH_0_7_0_164825828_12785_MIN_BASHVER=4.4

_LOBASH_0_7_0_164825828_12785_OS=$(_lobash.0_7_0_164825828_12785_detect_os)
readonly _LOBASH_0_7_0_164825828_12785_OS

_lobash.0_7_0_164825828_12785_is_bash() {
  [[ -n "${BASH_VERSION:-}" ]]
}

_lobash.0_7_0_164825828_12785_check_os() {
  if [[ ! $_LOBASH_0_7_0_164825828_12785_OS =~ ^(Linux|MacOS|BSD)$ ]]; then
    echo "Not support current system: $_LOBASH_0_7_0_164825828_12785_OS" >&2
    return 5
  fi
}

_lobash.0_7_0_164825828_12785_check_shell() {
  if ! _lobash.0_7_0_164825828_12785_is_bash; then
    echo 'Lobash only work in Bash.' >&2
    return 6
  fi
}

_lobash.0_7_0_164825828_12785_check_supported_bash_version() {
  local info
  read -r -d '.' -a info <<< "$_LOBASH_0_7_0_164825828_12785_MIN_BASHVER"
  if (( BASH_VERSINFO[0] < info[0] )) \
    || ( (( BASH_VERSINFO[0] == info[0] )) && (( BASH_VERSINFO[1] < info[1] )) ); then
    echo "Bash $BASH_VERSION is not supported. Upgrade your Bash to $_LOBASH_0_7_0_164825828_12785_MIN_BASHVER or higher version." >&2
    return 7
  fi
}

_lobash.0_7_0_164825828_12785_check_support() {
  _lobash.0_7_0_164825828_12785_check_os
  _lobash.0_7_0_164825828_12785_check_shell
  # _lobash.0_7_0_164825828_12785_check_supported_bash_version
}

_lobash.0_7_0_164825828_12785_check_support

_lobash.0_7_0_164825828_12785_dirname() {
  local str=${1:-}
  [[ $str == '/' ]] && echo '/' && return 0
  [[ $str =~ ^'../' ]] && echo '.' && return 0
  [[ ! $str =~ / ]] && echo '.' && return 0

  printf '%s\n' "${str%/*}"
}

_lobash.0_7_0_164825828_12785_with_IFS() {
  local IFS=$1
  shift
  eval "$*"
}

_lobash.0_7_0_164825828_12785_is_tty_available() {
  { : >/dev/tty ; } &>/dev/null
}

_lobash.0_7_0_164825828_12785_is_gnu_sed() {
  local out
  out=$(${1:-sed} --version 2>/dev/null)
  [[ $out =~ 'GNU sed' ]]
}

######################## Module Methods ########################

one_l.array_include() {
  local _exit_code_
  eval "(( \${#${1}[@]} == 0 )) && _exit_code_=1 || true"
  [[ -n ${_exit_code_:-} ]] && return "$_exit_code_"

  local _e_

  eval "for _e_ in \"\${${1}[@]}\"; do [[ \"\$_e_\" == \"$2\" ]] && _exit_code_=0 && return 0; done"
  [[ -n ${_exit_code_:-} ]] && return "$_exit_code_" || return 1
}

one_l.has() {
  local condition="$1"
  local value="$2"

  case "$condition" in
    command)
      [[ -x "$(command -v "$value")" ]] && return 0;;
    function)
      [[ $(type -t "$value") == function ]] && return 0;;
    alias)
      [[ $(type -t "$value") == alias ]] && return 0;;
    keyword)
      [[ $(type -t "$value") == keyword ]] && return 0;;
    builtin)
      [[ $(type -t "$value") == builtin ]] && return 0;;
    the)
      type -t "$value"
      return $?;;
    *)
      echo "Invalid Condition: $condition" >&2
      return 3;;
  esac > /dev/null

  return 1
}

one_l.has_not() {
  local e=false
  [[ $- =~ e ]] && e=true
  set +e
  one_l.has "${@}"
  local result=$?
  [[ $e == true ]] && set -e

  if [[ $result == 0 ]]; then
    return 1
  elif [[ $result == 1 ]]; then
    return 0
  else
    return $result
  fi
}

one_l.is_array() {
  [[ -z ${1:-} ]] && return 1

  local attrs
  attrs=$(one_l.var_attrs "$1")

  # a: array
  # A: associate array
  [[ ${attrs} =~ a|A ]]
}

one_l.var_attrs() {
  [[ -z ${1:-} ]] && return 1

  local attrs
  # shellcheck disable=2207
  attrs=$(declare -p "$1" 2>/dev/null || true)
  attrs=${attrs#* -}
  attrs=${attrs%% *}

  echo "${attrs#-}"
}

one_l.is_function() {
  [[ $(type -t "${1:-}") == function ]]
}

one_l.start_with() {
  [[ $1 =~ ^"$2" ]]
}


one_l.str_include() {
  [[ ${2:-} == '' ]] && return 0
  [[ "${1:-}" =~ "${2:-}" ]]
}

_l.0_7_0_164825828_12785_ask() {
  local msg=$1
  local default=$2
  local valid_values prompt
  valid_values="$(one_l.join values /)"

  if [[ $default == Y ]]; then
    default=yes
    prompt="[$valid_values (default ${default})]"
  elif [[ $default == N ]]; then
    default=no
    prompt="[$valid_values (default ${default})]"
  elif [[ $default == '' ]]; then
    prompt="[$valid_values]"
  else
    echo "Invalid argument 'default'. Valid value is $valid_values. Current=${default}" >&2
    return 3
  fi

  local answer result='' tty_available
  tty_available=$(_lobash.0_7_0_164825828_12785_is_tty_available && echo true || echo false)
  [[ $tty_available == true ]] && echo "$msg" >/dev/tty

  local loop_limit=10

  while [[ -z $result ]]; do
    read -rp "$prompt " answer

    if [[ -z $answer ]]; then
      if [[ -z $default ]]; then
        [[ $tty_available == true ]] && echo ">> Empty answer is not allowed." >/dev/tty
      else
        result="${default^^}"
      fi
    else
      local v
      for v in "${values[@]}"; do
        if one_l.start_with "$v" "${answer,,}"; then
          result="${v^^}"
          break
        fi
      done

      if [[ -z $result ]]; then
        [[ $tty_available == true ]] && echo ">> Invalid answer '$answer'." >/dev/tty
      fi
    fi

    loop_limit=$((loop_limit - 1))
    if ((loop_limit == 0)); then
      [[ $tty_available == true ]] && echo ">> Error: Reach the loop limit while asking" >/dev/tty
      return 4
    fi
  done
  echo "$result"
}

one_l.ask() {
  local values=(yes no)
  _l.0_7_0_164825828_12785_ask "$1" "${2:-}"
}

one_l.join() {
  if [[ $# == 1 ]]; then
    local IFS=,
  else
    local IFS=${2}
  fi
  eval "printf '%s\\n' \"\${${1}[*]:-}\""
}

one_l.str_replace() {
  local pattern=${2:-}
  if [[ $pattern =~ ^'#' ]]; then pattern="\\$pattern" ; fi
  if [[ $pattern =~ ^'%' ]]; then pattern="\\$pattern" ; fi
  echo "${1/$pattern/${3:-}}"
}

one_l.trim() {
  local str=${1:-}
  str=$(one_l.trim_start "$str")
  one_l.trim_end "$str"
}

one_l.trim_start() {
  local str=${1:-}
  if (( $# < 2 )); then
    # https://stackoverflow.com/a/3352015
    printf '%s\n' "${str#"${str%%[![:space:]]*}"}"
  else
    printf '%s\n' "${str##"$2"}"
  fi
}

one_l.trim_end() {
  local str=${1:-}
  if (( $# < 2 )); then
    # https://stackoverflow.com/a/3352015
    printf '%s\n' "${str%"${str##*[![:space:]]}"}"
  else
    printf '%s\n' "${str%%"$2"}"
  fi
}

one_l.detect_os() {
  _lobash.0_7_0_164825828_12785_detect_os
}

######################## Skipped Modules ########################
