# Advanced Usage

## ONE_RC

If shell has any critical issue and failed to start up, try `ONE_RC=<path-to-your-rcfile>` to change bashrc for rescue.

## ONE_DEBUG

Invoke `one debug true` and restart shell. You will see the debug logs on screen.

Invoke `one debug false` will turn off debug logs.

## ONE_PATHS

one.bash will reset `PATH` environment variable.
You can manage `PATH` by `ONE_PATHS` in your ONE_CONF.

## More

- [ONE Dependencies](./dep.md)
- [ONE Functions](./one-functions.md)
- [ONE_SUB Command](./one-sub-cmd.md)
- [Bash-it](./bash-it.md)
