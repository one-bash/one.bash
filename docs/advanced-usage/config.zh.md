# 配置

## 命令

你可以使用 `one config <key>=<val>` 来设置配置。（不支持函数和数组选项）

还可以用`one config <key>` 来查询选项。

## ONE_CONF

`ONE_CONF` 存放 one.bash 配置的文件路径。它的默认值是 `$HOME/.config/one.bash/one.config.bash`。

这个文件不是必须的，one.bash 有[默认配置](../../one.config.default.bash)。

## ONE_DIR

`ONE_DIR` 是 one.bash 所在目录。这个是常量，无需配置。

## ONE_CONF_DIR

`ONE_CONF_DIR` 是 ONE_CONF 文件所在目录。这个是常量，无需配置。

## ONE_RC

如果 one.bash 遇到严重的错误导致无法正常启动。你可以设置 `ONE_RC=<path-to-your-rcfile>` 用来急救。

## ONE_DEBUG

在配置文件中设置 `ONE_DEBUG=true`，或者调用 `one debug true`。然后重启 shell。
你会在屏幕看到 debug 日志输出。这些日志还会显示各个模块的加载时间。

调用 `one debug false` 关闭 debug。

## ONE_PATHS

one.bash 会用 ONE_PATHS 的值覆盖环境变量 `PATH` 的值。

## ONE_NO_MODS

当 `ONE_NO_MODS=true`，one.bash 不会加载任何模块。

`ONE_NO_MODS` 默认为 `false`.

## [ONE_LINKS_CONF](./linksz.zh.md#onelinksconf)
