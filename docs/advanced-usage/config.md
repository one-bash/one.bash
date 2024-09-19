# Configuration

## Commands

You can use `one config <key>=<val>` set config option. (function and array are not supported)

And `one config <key>` to query config option.

## ONE_CONF

`ONE_CONF` is the filepath of one.bash configuration. It defaults to `$HOME/.config/one.bash/one.config.bash`.

This file is not required. one.bash has [default config](../../one.config.default.bash).

## ONE_DIR

`ONE_DIR` is the directory where the one.bash located. This is a constant and does not need user to set.

## ONE_CONF_DIR

`ONE_CONF_DIR` is the directory where the ONE_CONF file located. This is a constant and does not need user to set.

## ONE_RC

If one.bash has any critical issue and failed to start up, you can set `ONE_RC=<path-to-your-rcfile>` for rescue.

## ONE_DEBUG

Set `ONE_DEBUG=true` in ONE_CONF file, or invoke `one debug true`. Then restart shell.
You will see the debug logs on screen. The logs showing the loading time for each module.

Invoke `one debug false` will turn off debug logs.

## ONE_PATHS

one.bash will overwrite `PATH` environment variable with the value of `ONE_PATHS`.

## ONE_NO_MODS

With `ONE_NO_MODS=true`, one.bash will not load any modules.

`ONE_NO_MODS` defaults to `false`.

## [ONE_LINKS_CONF](./links.md#onelinksconf)
