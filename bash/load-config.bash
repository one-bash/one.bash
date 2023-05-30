ONE_CONF=${ONE_CONF:-${XDG_CONFIG_HOME:-$HOME/.config}/one.bash/one.config.bash}

# shellcheck source=../deps/one_l.bash
. "$ONE_DIR/deps/one_l.bash"

# shellcheck source=~/.config/one.bash/one.config.bash
[[ -f $ONE_CONF ]] && . "$ONE_CONF"

# shellcheck source=../one.config.default.bash
. "$ONE_DIR/one.config.default.bash"
