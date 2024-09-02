ONE_CONF=${ONE_CONF:-${XDG_CONFIG_HOME:-$HOME/.config}/one.bash/one.config.bash}

# shellcheck source=../deps/one_l.bash
. "$ONE_DIR/deps/one_l.bash"

# shellcheck source=../one.config.default.bash
[[ -f $ONE_CONF ]] && . "$ONE_CONF"

ONE_CONF_DIR=$(dirname "$(realpath "$ONE_CONF")")

# shellcheck source=../one.config.default.bash
. "$ONE_DIR/one.config.default.bash"

readonly ONE_CONF ONE_CONF_DIR
