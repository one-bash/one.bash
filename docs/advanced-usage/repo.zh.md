# ONE Repo

## 仓库

one.bash 只是一个管理框架。它不包含任何配置文件。
推荐使用官方的 REPO [one.share][] 和 [one-bash-it][] ，它们提供了很多配置来增强 shell 体验。

## one repo 命令

- 列出所有本地 repo: `one repo list`
- 下载并启用 repo:
  - `one repo add https://github.com/one-bash/one.share`
  - `one repo add git@github.com:one-bash/one.share.git`
  - `one repo add /local/directory`
- 启用 repo: `one repo enable one.share`
- 禁用 repo: `one repo disable one.share`
- 更新 repo: `one repo update one.share`
- 删除 repo: `one repo remove one.share`
- 创建 repo: `one repo init`。具体请阅读[创建 Repo](#create-repo)。
- 在每个本地已启用的 Repo 中执行命令: `one repo exec ls`
- 显示本地的 repo 信息: `one repo info one.share`
- 搜索 Github 里的仓库 (topic: one-bash-repo): `one repo search`

`one repo` 显示命令用法。

## 创建 Repo

`one repo init` 创建 repo 项目脚手架。

### 目录结构

One Repo 的目录结构应该至少包含以下目录和文件。

```
.
├── alias/
│   └── alias.bash
├── bin/
│   └── file*
├── completion/
│   └── cmp.bash
├── config/
│   └── config-file
├── plugin/
│   └── plugin.bash
├── sub/
│   └── file*
└── one.repo.bash
```

- `file*` 文件必须是可执行的。
- `alias/` 存储 alias modules。
- `plugin/` 存储 plugin modules。
- `completion/` 存储 completion modules。
- `config/` 存储 dotfile, rcfile 和配置文件。
- `bin/` 存储命令。类似 `/usr/local/bin/`。文件必须是可执行的。
- `sub/` 存储 ONE_SUB 命令。文件必须是可执行的。用户使用 `$ONE_SUB <cmd>` 和 `one sub run <cmd>` 来调用它。

### one.repo.bash

one.repo.bash 文件内容:

```sh
ABOUT='the description of repo'

# If defined, this function will be executed in the process of bashrc initialization. See docs/develop/entry.md
# repo_onload() {
# }

# If defined, this function will be executed after downloading for  "one repo add".
# repo_add_post() {
# }

# If defined, this function will be executed before git update for "one repo update".
# repo_update_pre() {
# }

# If defined, this function will be executed after git update for "one repo update".
# repo_update_post() {
# }
```

<!-- links -->

[one.share]: https://github.com/one-bash/one.share
[one-bash-it]: https://github.com/one-bash/one-bash-it
[bash-it]: https://github.com/Bash-it/bash-it
