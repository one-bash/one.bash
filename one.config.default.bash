# User should define ONE_DIR in your bashrc
# shellcheck disable=2034

# The trigger name for sub commands. [Default: a]
# If set empty string, the `$ONE_SUB <cmd>` is not available, only `one sub run <cmd>` is available.
ONE_SUB=${ONE_SUB:-a}
# Filepath to script. If set, use this file as bashrc.
ONE_RC=${ONE_RC:-}
# If true, prints debug message when loading one.bash. You can see the loading time of each modules.
ONE_DEBUG=${ONE_DEBUG:-false}
# If loaded time greater ONE_DEBUG_SLOW_LOAD (in millisecond), highlight the loaded time.
ONE_DEBUG_SLOW_LOAD=${ONE_DEBUG_SLOW_LOAD:-100}
# If true, all one.bash modules will not be loaded
ONE_NO_MODS=${ONE_NO_MODS:-false}
# If fault error occurred, use the ONE_BASHRC_FO instead of
ONE_BASHRC_FO=${ONE_BASHRC_FO:-$ONE_DIR/bash/bashrc.failover.bash}
# The log file of one.bash
ONE_LOG_FILE=${ONE_LOG_FILE:-$ONE_DIR/tmp/one.log}

# Reset environment variable PATH.
# Most users don't need to modify ONE_PATHS.
one_l.is_array ONE_PATHS || ONE_PATHS=(
  # MacOS users notice: /usr/libexec/path_helper will set the PATH.
  # Refer to https://scriptingosx.com/2017/05/where-paths-come-from/
  # Further, Homebrew install Bash at $HOMEBREW_PREFIX/bin/bash, and MacOS default bash is at /bin/bash,

  # /usr/local/bin must before /bin in PATH
  /usr/local/bin
  /usr/local/sbin

  # /opt/homebrew for MacOS ARM arch
  /opt/homebrew/bin
  /opt/homebrew/sbin

  /usr/bin
  /bin
  /usr/sbin
  /sbin

  "$ONE_DIR/enabled/bin"
)

# Skip one.bash components
one_l.is_array ONE_SKIP_COMPS || ONE_SKIP_COMPS=()

# User should print the path of one.bash env file
# @param os type
one_l.is_function ONE_LINKS_CONF || ONE_LINKS_CONF="${ONE_LINKS_CONF:-$ONE_CONF_DIR/one.links.yaml}"
