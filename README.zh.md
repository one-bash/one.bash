<p align="center">
  <img alt="LOGO" src="https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/one.bash/banner.svg">
  <b>Make Bash Great Again!</b>
</p>

模块化管理命令、补全脚本、dotfile 配置的框架，适合 bash 用户。

[English](./README.md) | [中文](./README.zh.md)

## 功能

- 链接：集中管理一系列配置文件。基于 YAML 文件，使用 `one link` 和 `one unlink` 命令来管理软链接。
- 模块：通过[模块][one-module]管理 shell 脚本、补语、别名、命令、子命令。支持自定义模块。
- 仓库：通过 [repo][one-repo] 轻松分享和重用可执行文件、子命令、配置和模块。支持自定义 repo 和多个 repo。
- 子命令：可以在一个作用域下管理自己的命令。如 `a <cmd>` 来调用命令，避免在 `PATH` 中重复命令。请阅读 [ONE_SUB Commands][one-sub]。
- 可配置的 one.bash：请阅读 [ONE_CONF](#oneconf)。
- 支持 [bash-it][]：使用 [one-bash-it][] 即可。你可以使用 `one` 命令来管理 bash-it 的 aliases/completions/plugins。

## 环境

- ✅ iTerm2
- ✅ Terminal.app
- ✅ MacOS 13 及以上版本 (Intel/ARM 架构)
- ✅ Linux/Unix 系统
- 🚫 Windows 系统
- 🚫 Zsh。本项目针对 Bash 用户开发. Zsh 用户请使用 [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)。

## 版本

详见 [releases][]。
版本命名遵守 [SemVer 2.0.0](http://semver.org/)。

## 必要的依赖

- GNU Bash 4.4 or 5.0+
- [python3](https://www.python.org/)
- [perl 5](https://github.com/Perl/perl5)
- [git](https://github.com/git/git)
- sed, awk, grep, find

## 灵感来源

one.bash 的灵感来自 [sub][] 和 [bash-it][]。

- sub。由 basecamp 创建的一个用来组织管理 shell 程序的框架。但已不再维护。
- bash-it。一个社区驱动的 Bash 框架。

## 谁在用 one.bash

详见 https://github.com/topics/one-bash

( 你可以在你的 Github 项目里添加 `one-bash` topic，以便分享。 )

## 安装

```sh
# 设置 one.bash 的安装路径
ONE_DIR=~/.one.bash
git clone --depth 1 https://github.com/one-bash/one.bash.git $ONE_DIR
# 注意：你需要确保 /usr/local/bin/ 在环境变量 PATH 中
sudo ln -s "$ONE_DIR/bin/one" /usr/local/bin/one

# 安装依赖
one dep install

# 把 one.bash 加入到你的 bashrc。或者你也可以手动将 `one --bashrc` 的结果写入 bashrc。
echo '' >> ~/.bashrc
one --bashrc >> ~/.bashrc
```

## 更新

```sh
# 更新 one.bash 以及相关依赖到最新版本
one upgrade
# 检查依赖状态
one dep status
```

## 快速上手

```bash
# Add a repo
one repo add one-bash/one.share
one repo add one-bash/bash-it

# List available plugins/completions/aliases/bins/subs
one plugin list -a
one completion list -a
one alias list -a
one bin list -a
one sub list -a

# Enable modules on demand
# one plugin enable <name>
# one completion enable <name>

# Restart your shell
```

### 注意

1. 每次启用或禁用任何模块。需要重启当前 shell 才能生效。
2. 如果 shell 遇到任何严重问题并无法启动，使用 `one config --edit` 编辑你的 [ONE_CONF](#oneconf) 文件，并且设置 `ONE_RC=<path-to-your-rcfile>` 来更改 bashrc 进行救援。

### one link

创建一个 YAML 文件，路径为 `$HOME/.config/one.bash/one.links.yaml`。

```yaml
# It is just an example. All belows are unnecessary.
- defaults:
    link:
      # relink: true # If true, override the target file when it existed
      create: true

# ONE_SHARE_DIR is the filepath of repo https://github.com/one-bash/one.share
# You must enable the repo one.share before invoking "one link"
- link:
    # configs
    ~/.tmux.conf: $ONE_SHARE_DIR/configs/tmux/tmux.conf
    $XDG_CONFIG_HOME/bat/config: $ONE_SHARE_DIR/configs/bat
    $XDG_CONFIG_HOME/starship.toml: $ONE_SHARE_DIR/configs/starship.toml
```

调用 `one link` 来创建软链接。

## [配置](./docs/advanced-usage/config.zh.md)

## [文档](./docs)

- [Bashrc 初始化过程](./docs/develop/entry.zh.md)
- [模块][one-sub]
- [One Repo][one-repo]
- [ONE_SUB 命令][one-sub]
- [ONE Links](./docs/advanced-usage/links.zh.md)
- [ONE Dependencies](./docs/advanced-usage/dep.zh.md)
- [ONE Functions](./docs/advanced-usage/one-functions.md)
- [项目文件结构](./docs/develop/project-structure.md)

## 用法

`one` 命令用来管理 one.bash [仓库][one-repo]和[模块][one-module]、配置以及依赖。

```bash
# 调用 `one` 会显示用法。
$ one
Usage:
    one help [<CMD>]            Show the usage of one command
    one [<CMD>] [-h|--help]     Show the usage of one command
    one help-sub [<SUB_CMD>]    Show the usage of ONE_SUB command

    one r
    one repo                    Manage one.bash repos
    one a
    one alias                   Manage aliases in ONE_REPO/alias/
    one b
    one bin                     Manage executable files in ONE_REPO/bin/
    one c
    one completion              Manage completions in ONE_REPO/completion/
    one p
    one plugin                  Manage plugins in ONE_REPO/plugin/

    one enabled                 Manage enabled modules (alias/completion/plugin)
    one disable-all             Disable all modules (alias/completion/plugin)

    one backup                  Output backup scripts for current enabled modules
    one config                  Manage user's ONE_CONF
    one debug                   Toggle debug mode on one.bash
    one dep                     Manage one.bash deps
    one link                    Create symlink files based on LINKS_CONF file
    one unlink                  remove all symbol links based on LINKS_CONF file
    one upgrade                 Upgrade one.bash and its dependencies to latest version
    one log                     Tail the logs of one.bash
    one search                  Search alias/bin/completion/plugin of each enabled repo.
    one sub [<SUB_CMD>]         Run ONE_SUB command
    one status                  Print one.bash status
    one version                 Print current version of one.bash
    one --bashrc                Print one.bash entry codes for bashrc

Desc: A modular framework that manages commands, completions, dotfiles for bash users.

Source Code: https://github.com/one-bash/one.bash

Arguments:
    <CMD>                       The one command
    <SUB_CMD>                   The ONE_SUB command
```

## 提建议，修 Bug，做贡献

欢迎提供任何建议或者意见。

**在创建新的 Issue/Discussion/PR，以及发表评论之前**，请先阅读[贡献指南](./docs/CONTRIBUTING.zh.md)。

## 版权声明

Copyright 2022-2024 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

Read the [LICENSE][] file for the specific language governing permissions and limitations under the License.

Read the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## 其他项目

- [lobash](https://github.com/adoyle-h/lobash): 帮助 Bash 脚本开发的现代化、安全、强大的工具库。
- [其他我创建的 shell 项目](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers)


<!-- links -->

[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
[releases]: https://github.com/one-bash/one.bash/releases

<!-- links -->

[one.share]: https://github.com/one-bash/one.share
[one-bash-it]: https://github.com/one-bash/one-bash-it
[one.config.default]: ./one.config.default.bash
[composure]: https://github.com/adoyle-h/composure.git
[dotbot]: https://github.com/anishathalye/dotbot/
[bash-it]: https://github.com/Bash-it/bash-it
[bash-completion]: https://github.com/scop/bash-completion
[sub]: https://github.com/basecamp/sub
[one-repo]: ./docs/advanced-usage/repo.zh.md
[one-module]: ./docs/advanced-usage/module.zh.md
[one-sub]: ./docs/advanced-usage/one-sub-cmd.zh.md
