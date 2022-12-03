# Advanced Usage

## Custom

You can create your own repo by `one repo init`.

`one help repo` for usage.

Read [ONE Repo](./repo.md) for details.

## ONE_RC

If one.bash has any critical issue and failed to start up, you can set `ONE_RC=<path-to-your-rcfile>` for rescue.

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
- [Fig](./fig.md)
- [Bash-it](./bash-it.md)
