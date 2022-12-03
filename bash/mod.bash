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
    find -L "$dir" -maxdepth 1 -type f -name "*.bash" -exec basename {} ".bash" \;
  done
}

compgen_disable_mod() {
  # shellcheck disable=2154
  find "$ENABLED_DIR" -maxdepth 1 -type l -name "*---*.$t.bash" -print0 \
    | xargs -0 -I{} basename '{}' ".$t.bash" \
    | sed -E 's/^[[:digit:]]{3}---(.+)$/\1/' || true

  echo "-a"
}

# -----------------------------------------------------------------------------

list_enabled() {
  find "$ENABLED_DIR" -maxdepth 1 -type l \
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

    find -L "$ONE_REPO/$ts" -maxdepth 1 -type f -exec basename {} ".bash" \;
  done
}

list_mod_path() {
  local ONE_REPO
  # shellcheck disable=2153
  for ONE_REPO in "${ONE_REPOS[@]}"; do
    # shellcheck disable=2154
    if [[ ! -d "$ONE_REPO/$ts" ]]; then continue; fi

    find -L "$ONE_REPO/$ts" -maxdepth 1 -type f | sort | tr '\n' ' '
  done
}

# -----------------------------------------------------------------------------

# List all paths matched $ENABLED_DIR/*---$name.$t.bash
match_enabled_modules() {
  local name=$1
  compgen -G "$ENABLED_DIR/*---$name.$t.bash" || true
}

disable_mod() {
  local name=$1
  local silent=${2:-false}
  local filepath
  local found=false

  while read -r -d $'\n' filepath; do
    if [[ -h $filepath ]] || [[ -f $filepath ]]; then
      unlink "$filepath"
      echo "Disabled $(basename "$filepath"). Please restart shell to take effect."
      found=true
    fi
  done < <(match_enabled_modules "$name")

  if [[ $silent == false ]] && [[ $found == false ]]; then
    echo "Not found enabled $t '$name'." >&2
  fi
}

disable_it() {
  if [[ ${1:-} == -a ]]; then
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

get_weight() {
  local weight

  weight=$(head "$1" | grep -Eo '^# (ONE|BASH_IT)_LOAD_PRIORITY: \d{3}$' | grep -Eo '\d{3}' || true)

  if [[ -z "$weight" ]]; then
    echo "${default_weight_map[$t]}"
  else
    echo "$weight"
  fi
}

enable_file() {
  local name=$1
  local filepath=$2
  local weight
  weight=$(get_weight "$filepath")

  # Disable first, prevent duplicated module enabled with different weight
  disable_mod "$name" true
  ln -sf "$filepath" "$ENABLED_DIR/$weight---$name.$t.bash"

  echo "Enabled $weight---$name.$t.bash. Please restart shell to take effect."
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

enable_mod() {
  local name=$1 filepath

  filepath=$(search_mod "$name")

  if [[ -n $filepath ]]; then
    enable_file "$name" "$filepath" || echo "Failed to enable '$name'."
  else
    echo "No found $t '$name'." >&2
  fi
}

enable_it() {
  local name
  for name in "$@"; do
    enable_mod "$name"
  done
}
