ONE_CONF=${ONE_CONF:-${XDG_CONFIG_HOME:-$HOME/.config}/one.bash/one.config.bash}

# shellcheck source=../deps/one_l.bash
. "$ONE_DIR/deps/one_l.bash"

# shellcheck source=../one.config.default.bash
[[ -f $ONE_CONF ]] && . "$ONE_CONF"

ONE_CONF_DIR=$(realpath "$ONE_CONF")
ONE_CONF_DIR=${ONE_CONF_DIR%/*}

# shellcheck source=../one.config.default.bash
. "$ONE_DIR/one.config.default.bash"

readonly ONE_CONF ONE_CONF_DIR
