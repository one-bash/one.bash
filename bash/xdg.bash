# The XDG_ variables definitions:
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables

## User directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}/xdg-$USER}

## System directories
# a set of preference ordered base directories relative to which data files should be searched
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
# a set of preference ordered base directories relative to which configuration files should be searched
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg}
