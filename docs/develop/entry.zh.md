# one.bash entry.bash

## Bashrc 初始化过程

它将按照以下顺序执行脚本：

- `~/.profile` 或 `~/.bash_profile`
- `~/.bashrc`
- [bash/entry.bash](../bash/entry.bash)
  - 加载 [exit codes](../bash/exit-codes.bash)
  - 加载 `$ONE_CONF` (默认为 `$HOME/.config/one.bash/one.config.bash`)
  - 加载 [one.config.default.bash](../one.config.default.bash)
  - 重置 PATH: [bash/path.bash](../bash/path.bash)
  - 设置 XDG 环境变量: [bash/xdg.bash](../bash/xdg.bash)
  - 如果 `$ONE_RC` 不为空，则进入 `$ONE_RC`，并且不会执行以下步骤。
  - 如果 `check_shell` 失败，则进入 `$ONE_BASHRC_FO`，并且不会执行以下步骤。
  - 加载 [composure](https://github.com/adoyle-h/composure.git)
  - 加载操作系统设置。
  - 启用 `one` 和 `$ONE_SUB` 的自动补全。[bash/one-complete.bash](../bash/one-complete.bash)
  - 如果在每个仓库的 `one.repo.bash` 中定义了 `repo_onload` 函数，则执行它。
  - 如果 `ONE_NO_MODS` 为 false，加载 [enabled modules](../enabled/)
