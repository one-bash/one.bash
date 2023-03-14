# you can extend the mod map
# shellcheck disable=2034
readonly -A t_map=(
  [plugin]=plugins
  [completion]=completions
  [alias]=aliases
)

readonly -A default_weight_map=(
  [plugin]=400
  [completion]=600
  [alias]=750
)

readonly ENABLED_DIR=$ONE_DIR/enabled

# NOTE: DO NOT modify the value of mod_annotation
readonly mod_annotation='# This file is generated by one.bash. Do not edit the content by manual.'

# $ts and $t are defined in caller

# -----------------------------------------------------------------------------

compgen_enable_mod() {
  declare -a plugin_dirs=()

  # shellcheck disable=2153
  for ONE_REPO in "${ONE_REPOS[@]}" ; do
    # shellcheck disable=2154
    if [[ -d "$ONE_REPO/$ts" ]]; then
      plugin_dirs+=( "$ONE_REPO/$ts" )
    fi
  done

  for dir in "${plugin_dirs[@]}" ; do
    find -L "$dir" -maxdepth 1 -type f -name "*.bash" -exec basename {} ".bash" \; | sed -E 's/\.opt$//'
  done
}

compgen_disable_mod() {
  # shellcheck disable=2154
  find "$ENABLED_DIR" -maxdepth 1 -name "*---*.$t.bash" -print0 \
    | xargs -0 -I{} basename '{}' ".$t.bash" \
    | sed -E 's/^[[:digit:]]{3}---(.+)$/\1/' || true

  echo "--all"
}

# -----------------------------------------------------------------------------

list_enabled() {
  find "$ENABLED_DIR" -maxdepth 1 \
    -name "*---*.$1.bash" \
    -exec basename {} ".$1.bash" \; \
    | sed -E 's/^[[:digit:]]{3}---(.+)$/\1/'
}

list_mod() {
  local ONE_REPO
  # shellcheck disable=2153
  for ONE_REPO in "${ONE_REPOS[@]}"; do
    # shellcheck disable=2154
    if [[ ! -d "$ONE_REPO/$ts" ]]; then continue; fi

    find -L "$ONE_REPO/$ts" -maxdepth 1 -type f -exec basename {} ".bash" \; | sed -E 's/\.opt$//'
  done
}

# -----------------------------------------------------------------------------

# List all paths matched $ENABLED_DIR/*---$name.$t.bash
match_enabled_modules() {
  local name=$1
  compgen -G "$ENABLED_DIR/*---$name.$t.bash" || true
}

_disable_mod() {
  local filepath=$1
  local target
  target=$(readlink "$filepath")

  if [[ -e "$target" ]] && grep "^$mod_annotation" "$filepath" &>/dev/null ; then
    unlink "$target"
  fi

  unlink "$filepath"
}

disable_mod() {
  local name=$1
  local silent=${2:-false}
  local filepath
  local found=false

  while read -r -d $'\n' filepath; do
    if [[ -h $filepath ]] || [[ -f $filepath ]]; then
      _disable_mod "$filepath"
      echo "Disabled $(basename "$filepath"). Please restart shell to take effect."
      found=true
    fi
  done < <(match_enabled_modules "$name")

  if [[ $silent == false ]] && [[ $found == false ]]; then
    echo "Not found enabled $t '$name'." >&2
  fi
}

disable_it() {
  if [[ ${1:-} == --all ]]; then
    for name in $(list_enabled "$t"); do
      disable_mod "$name" || echo "Failed to enable '$name'."
    done
  else
    for name in "$@"; do
      disable_mod "$name" || echo "Failed to enable '$name'."
    done
  fi
}

# -----------------------------------------------------------------------------

check_file() {
  local name=$1
  # shellcheck disable=2154
  if [[ ! -f "$t_dir/$name.bash" ]]; then
    echo "No found $t '$name'" >&2
    exit 1
  fi
}

# Search in ONE_REPO/<mod_type>/<name>.bash
search_mod() {
  local name=$1
  local ONE_REPO

  for ONE_REPO in "${ONE_REPOS[@]}" ; do
    if [[ -f "$ONE_REPO/$ts/$name.bash" ]]; then
      echo "$ONE_REPO/$ts/$name.bash"
      return
    fi
  done

  printf '\n'
}

_ask_update_mod_data() {
  local target=$1
  local answer

  if [[ -e $target ]]; then
    read -r -p "Find existed data which may be outdated. Do you want to update it to latest? (y/[n])" answer
    if [[ ${answer:-n} == y ]]; then
      rm -rf "$target"
    else
      return 1;
    fi
  fi
  echo "To download data..."
}

download_mod_data() {
  local name=$1 url answer
  url=$(get_opt "$opt_path" URL)

  local MOD_DATA_ROOT="$ONE_DIR/data/$ts"
  local MOD_DATA_DIR="$MOD_DATA_ROOT/${name}"
  mkdir -p "$MOD_DATA_DIR"

  if l.end_with "$url" '.git'; then
    local target="$MOD_DATA_DIR/git"
    if _ask_update_mod_data "$target"; then
      printf 'To git clone "%s" "%s"\n' "$url" "$target" >&2
      git clone --depth 1 --single-branch --recurse-submodules --shallow-submodules "$url" "$target"
    fi
  elif [[ -n $url ]]; then
    local target="$MOD_DATA_DIR/script.bash"
    if _ask_update_mod_data "$target"; then
      printf 'To curl -Lo "%s" "%s"\n' "$target" "$url" >&2
      curl -Lo "$target" "$url"
    fi
  fi
}

# @param $1 The filepath that stores options
# @param $2 The key
get_opt() {
  # shellcheck disable=1090
  (source "$1" && eval "echo \"\${$2:-}\"")
}

# Create completion mod file
create_mod() {
  local name=$1
  local MOD_DATA_ROOT="$ONE_DIR/data/$ts"
  local MOD_DATA_DIR="$MOD_DATA_ROOT/${name}"
  local MOD_FILE="$MOD_DATA_DIR/mod.bash"
  local log_tag="enable:$t:$name"

  local ONE_LOAD_PRIORITY SCRIPT APPEND INSERT ABOUT URL RUN

  APPEND=$(get_opt "$opt_path" APPEND)
  INSERT=$(get_opt "$opt_path" INSERT)
  RUN=$(get_opt "$opt_path" RUN)

  if [[ -n "${RUN:-}" ]]; then
    log_verb "$log_tag:RUN" "$RUN"
    # shellcheck disable=2094
    (eval "$RUN" 2>&1 1>>"$ONE_LOG_FILE" | tee -a "$ONE_LOG_FILE" >&2) ||
      { log_err "$log_tag:RUN" "[Failed] $RUN"; return 7; }
  fi

  ONE_LOAD_PRIORITY=$(get_opt "$opt_path" ONE_LOAD_PRIORITY)
  ABOUT=$(get_opt "$opt_path" ABOUT)
  SCRIPT=$(get_opt "$opt_path" SCRIPT)
  URL=$(get_opt "$opt_path" URL)

  local target_script
  if [[ -n ${URL:-} ]]; then
    target_script="$MOD_DATA_DIR/${SCRIPT:-script.bash}"
  fi

  echo "$mod_annotation" > "$MOD_FILE"

  {
    if [[ -n "${ABOUT:-}" ]]; then
      printf '# About: %s\n' "$ABOUT"
    fi

    if [[ -n "${ONE_LOAD_PRIORITY:-}" ]]; then
      echo "# ONE_LOAD_PRIORITY: $ONE_LOAD_PRIORITY"
    fi

    if [[ -n "${INSERT:-}" ]]; then
      log_verb "$log_tag:INSERT" "$INSERT"
      printf '\n'
      (eval "$INSERT" 2> >(tee -a "$ONE_LOG_FILE" >&2)) ||
        { log_err "$log_tag:INSERT" "[Failed] $INSERT"; return 8; }
    fi

    if [[ -n "${target_script:-}" ]]; then
      printf '\nsource %s\n' "$target_script"
    fi

    if [[ -n "${APPEND:-}" ]]; then
      log_verb "$log_tag:APPEND" "$APPEND"
      printf '\n'
      (eval "$APPEND" 2> >(tee -a "$ONE_LOG_FILE" >&2)) ||
        { log_err "$log_tag:APPEND" "[Failed] $APPEND"; return 9; }
    fi
  } >> "$MOD_FILE"

  echo "$MOD_FILE"
}

get_weight() {
  local weight

  weight=$(head "$1" | grep -Eo '^# (ONE|BASH_IT)_LOAD_PRIORITY: \d{3}$' | grep -Eo '\d{3}' || true)

  if [[ -z "$weight" ]]; then
    echo "${default_weight_map[$t]}"
  else
    echo "$weight"
  fi
}

get_enabled_link_to() {
  local name=$1
  local path
  shopt -s nullglob
  path=$(echo "$ENABLED_DIR/"*---"$name.$t.bash")
  shopt -u nullglob
  if [[ -n $path ]]; then
    readlink "$path"
  fi
}

enable_file() {
  local name=$1
  local filepath=$2
  local weight
  weight=$(get_weight "$filepath")

  ln -sf "$filepath" "$ENABLED_DIR/$weight---$name.$t.bash"

  echo "Enabled $weight---$name.$t.bash. Please restart shell to take effect."
}

check_opt_mod_dep_cmds() {
  local -a DEP_CMDS
  # shellcheck disable=2207
  IFS=' ' DEP_CMDS=( $(get_opt "$opt_path" DEP_CMDS) )

  local cmd
  for cmd in "${DEP_CMDS[@]}"; do
    if one_l.has_not command "$cmd"; then
      printf "The command '%s' is required but not found in host.\nSee %s to install it.\n"  "$cmd" "https://command-not-found.com/$cmd" >&2
      return 10
    fi
  done
}

enable_mod() {
  local name=$1 filepath

  filepath=$(search_mod "$name")

  if [[ -n $filepath ]]; then
    # Disable first, prevent duplicated module enabled with different weight
    disable_mod "$name" true
    enable_file "$name" "$filepath" || echo "Failed to enable '$name'."
  else
    local opt_path
    opt_path=$(search_mod "$name.opt")

    if [[ -n $opt_path ]]; then
      check_opt_mod_dep_cmds
      # Disable first, prevent duplicated module enabled with different weight
      disable_mod "$name" true
      download_mod_data "$name" "$opt_path"
      filepath=$(create_mod "$name")
      enable_file "$name" "$filepath" || echo "Failed to enable '$name'."
    else
      echo "No found $t '$name'." >&2
    fi
  fi
}

enable_it() {
  local name
  for name in "$@"; do
    enable_mod "$name"
  done
}

# -----------------------------------------------------------------------------

print_list_item() {
  local line type

  declare -A MOD_TYPE_COLOR=(
    ['completion']=$GREEN
    ['plugin']=$BLUE
    ['alias']=$RED
  )

  while read -r line; do
    read -r -a list < <(basename "$line" | sed -E "s/^([[:digit:]]{3})---(.+)\.(.+)\.bash\$/\1 \2 \3/")
    type=${list[2]:0:1}

    local -a prints=()
    local format=''

    # mod type
    if [[ ${opts['type']:-} != false ]]; then
      format="$format%b%s "
      prints+=("${MOD_TYPE_COLOR[${list[2]}]}" "${type^}")
    fi

    # load-priority
    if [[ ${opts['priority']:-} != false ]]; then
      format="$format%b%s "
      prints+=("$YELLOW" "${list[0]}")
    fi

    # mod name -> real path
    format="$format%b%s%b -> %b%s\n"
    prints+=(
      "$CYAN" "${list[1]}" "$GREY"
      "$RESET_ALL" "$(readlink "$line")"
    )

    # shellcheck disable=2059
    printf "$format" "${prints[@]}"
  done
}

list_mods() {
  if [[ -z ${RESET_ALL:-} ]]; then
    # shellcheck source=../../deps/colors.bash
    . "$ONE_DIR/deps/colors.bash"
  fi

  if [[ -n "${opts[a]:-}" ]]; then
    # list all available mods
    if [[ -n "${opts[n]:-}" ]]; then
      # list only mod names
      list_mod | tr '\n' ' '
      printf '\n'
    else
      local ONE_REPO
      # shellcheck disable=2153
      for ONE_REPO in "${ONE_REPOS[@]}"; do
        # shellcheck disable=2154
        if [[ ! -d "$ONE_REPO/$ts" ]]; then continue; fi

        printf '%b%s%b\n' "$BLUE" "[$ONE_REPO/$ts]" "$RESET_ALL"
        find -L "$ONE_REPO/$ts" -maxdepth 1 -type f -exec basename {} .bash \; | sed -E 's/\.opt$//'| tr '\n' ' '
        printf '\n'
      done
    fi
  else
    # list all enabled mods
    if [[ -n "${opts[n]:-}" ]]; then
      # list only mod names
      list_enabled "$t" | tr '\n' ' '
      printf '\n'
    else
      find "$ENABLED_DIR" -maxdepth 1 -name "*---*.$t.bash" | print_list_item
    fi
  fi
}

# -----------------------------------------------------------------------------

metafor () {
  local keyword=$1;
  # Copy from composure.sh
  sed -n "/$keyword / s/['\";]*\$//;s/^[      ]*\(: _\)*$keyword ['\"]*\([^([].*\)*\$/\2/p"
}

info_mod() {
  local name=$1
  local filepath

  filepath=$(search_mod "$name")

  local ABOUT URL SCRIPT ONE_LOAD_PRIORITY

  local enabled link_to
  link_to=$(get_enabled_link_to "$name")

  if [[ -n $filepath ]]; then
    if [[ -n $link_to ]]; then
      echo "Enabled: true"
      echo "Link to: $link_to"
    else
      echo "Enabled: false"
    fi
    ABOUT=$(metafor about-plugin <"$filepath")
    ONE_LOAD_PRIORITY=$(get_weight "$filepath")
    [[ -n ${ABOUT:-} ]] && echo "About: $ABOUT";
    [[ -n ${ONE_LOAD_PRIORITY:-} ]] && echo "Priority: $ONE_LOAD_PRIORITY";
  else
    local opt_path
    opt_path=$(search_mod "$name.opt")

    if [[ -n $opt_path ]]; then
      # shellcheck disable=1090
      (source "$opt_path" && {
        if [[ -n $link_to ]]; then
          echo "Enabled: true"
          echo "Link to: $link_to"
        else
          echo "Enabled: false"
        fi
        [[ -n ${ABOUT:-} ]] && echo "About: $ABOUT";
        [[ -n ${ONE_LOAD_PRIORITY:-} ]] && echo "Priority: $ONE_LOAD_PRIORITY";
        echo "Opt File: $opt_path"
        [[ -n ${URL:-} ]] && echo "URL: $URL";
        [[ -n ${SCRIPT:-} ]] && echo "Script: $SCRIPT";
        [[ -n ${DEP_CMDS:-} ]] && echo "DEP_CMDS: $DEP_CMDS";
      })
    else
      echo "No found $t '$name'." >&2
    fi
  fi
}
