<p align="center">
  <img alt="LOGO" src="https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/one.bash/banner.svg">
  <b>Make Bash Great Again!</b>
</p>

一个优雅管理命令、shell 脚本，自动补全、配置的框架，适合 bash 玩家。

[English](./README.md) | [中文](./README.zh.md)

## 功能

- 集中管理一系列配置文件。使用 YAML 文件通过 [dotbot][] 来管理软链接。
- 通过[模块](#模块)管理 shell 脚本、补语、别名。支持自定义模块。
- 通过 [repo](#onerepos) 轻松分享和重用可执行文件、子命令、配置和模块。请阅读 [one.share][]。
- 支持自定义 repo 和多个 repo。由 [`ONE_REPOS`](#onerepos) 管理。
- 可以在一个作用域下管理自己的命令。如 `a <cmd>` 来调用命令，避免在 `PATH` 中重复命令。请阅读 [ONE_SUB Commands](./docs/advanced-usage/one-sub-cmd.md)。
- 支持 one.bash 配置。阅读 [ONE_CONF](#oneconf)。
- 支持 [bash-it][]。你可以使用 one 命令来管理 bash-it 的 aliases/completions/plugins。请阅读 [bash-it.md](./docs/advanced-usage/bash-it.md)。
- 支持 [Fig][]。请阅读 [docs/advanced-usage/fig.md](./docs/advanced-usage/fig.md)。

## 环境

- ✅ iTerm2
- ✅ Terminal.app
- ✅ MacOS Intel Arch
- ✅ MacOS ARM Arch
- ✅ Linux/Unix system
- 🚫 Windows system
- 🚫 Zsh. 本项目针对 Bash 用户开发. Zsh 用户请使用 [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)。

## CI 状态

- [develop 分支](https://github.com/one-bash/one.bash/tree/develop): [![CI 状态](https://github.com/one-bash/one.bash/actions/workflows/ci.yaml/badge.svg?branch=develop)](https://github.com/one-bash/one.bash/actions/workflows/ci.yaml?query=branch%3Adevelop)

## 版本

详见 [tags][]。
版本命名遵守 [SemVer 2.0.0](http://semver.org/)。

## 依赖

### 必要的依赖

- GNU Bash 4.4 or 5.0+
- [python3](https://www.python.org/)
- [perl 5](https://github.com/Perl/perl5)
- [git](https://github.com/git/git)

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

## 配置

### ONE_CONF

`ONE_CONF` 存放 one.bash 配置的文件路径。
这个文件不是必须的，one.bash 有[默认配置](./one.config.default.bash)。

```sh
ONE_CONF=${XDG_CONFIG_HOME:-$HOME/.config}/one.bash/one.config.bash
mkdir -p "$(dirname "$ONE_CONF")"

# Create your dotfiles on any path.
DOTFILES_DIR=$HOME/.dotfiles
mkdir -p "$DOTFILES_DIR"

cat <<-EOF >"$ONE_CONF"
DOTFILES_DIR="$DOTFILES_DIR"

ONE_DEBUG=false
ONE_REPOS=(
  "$DOTFILES_DIR"
)
ONE_LINKS_CONF() {
  case "$1" in
    *) echo "$DOTFILES_DIR"/one.links.yaml ;;
  esac
}
EOF

. "$ONE_CONF"
```

请阅读 [./one.config.default.bash][one.config.default] 获知更多 ONE_CONF 配置选项和使用文档。

你可以使用 `one config <key>=<val>` 来设置配置。（不支持函数和数组选项）

还可以用`one config <key>` 来查询选项。

### ONE_LINKS_CONF

`ONE_LINKS_CONF` 是一个 Bash 函数，它返回 [dotbot][] 配置的文件路径。默认为空。

该函数接收两个参数：OS (`uname -s`) 和 Arch (`uname -m`)。
它可以用来管理不同系统下的不同 [dotbot][] 配置（比如 MacOS 和 Linux）。

```sh
# User should print the path of ONE_LINKS_CONF file
# @param os   $(uname -s)
# @param arch $(uname -m)
ONE_LINKS_CONF() {
  local os=$1
  local arch=$2
  case "$os_$arch" in
    Darwin_arm64) echo "$DOTFILES_DIR"/links/macos_arm.yaml ;;
    Darwin_amd64) echo "$DOTFILES_DIR"/links/macos_intel.yaml ;;
    Linux*) echo "$DOTFILES_DIR"/links/linux.yaml ;;
  esac
}
```

[dotbot][] 是一个通过软链接管理配置文件（或者任何文件）的工具。
你可以用它来创建软链接，指向任何文件。

[one.share][] 提供了一个 dotbot 配置模板。你可以拷贝 [one.links.example.yaml][] 到你的目录。

```sh
cp "$ONE_SHARE_DIR"/one.links.example.yaml "$DOTFILES_DIR"/one.links.yaml
# Edit the one.links.yaml for your demand
$EDITOR "$DOTFILES_DIR"/one.links.yaml
```

调用 `one link` 会根据 ONE_LINKS_CONF 创建软链接。
**注意: 不要用 sudo 调用 `one link`。**

调用 `one unlink` 会根据 ONE_LINKS_CONF 移除软链接文件。

你可以使用 [dotbot 插件](https://github.com/anishathalye/dotbot#plugins) 来获得更多指令。
详见 https://github.com/anishathalye/dotbot/wiki/Plugins

## 用法

如果 `ONE_SHARE_ENABLE` 为 true，调用 `$ONE_SHARE_ENABLE/recommended-modules` 来启动 one.share 推荐的模块。

如果 `ONE_BASH_IT_ENABLE` 为 true，调用 `one completion enable aliases.completion`。

## ONE 命令

`one` 命令用来管理 one.bash 模块、配置以及依赖。

调用 `one` 会显示用法。

```
Usage:
    one help [<CMD>]            Show the usage of one command
    one [<CMD>] [-h|--help]     Show the usage of one command
    one help-sub [<SUB_CMD>]    Show the usage of ONE_SUB command

    one repo                    Manage one.bash repos
    one alias                   Manage aliases in ONE_REPO/aliases/
    one bin                     Manage commands in ONE_REPO/bin/
    one completion              Manage completions in ONE_REPO/completions/
    one plugin                  Manage plugins in ONE_REPO/plugins/
    one enabled                 Manage enabled modules (alias/completion/plugin)

    one config                  Manage user's ONE_CONF
    one commands                List one commands
    one debug                   Toggle debug mode on one.bash
    one dep                     Manage one.bash deps
    one link                    Create symlink files based on LINKS_CONF file
    one unlink                  remove all symbol links based on LINKS_CONF file
    one log                     Tail the logs of one.bash
    one sub [<SUB_CMD>]         Run ONE_SUB command
    one subs                    List ONE_SUB commands
    one [--bashrc]              Print one.bash entry codes for bashrc

Desc:
    An elegant framework to manage commands, completions, dotfiles for terminal players.
    Source code: https://github.com/one-bash/one.bash
    /Users/adoyle/.config/one.bash/one.config.bash

Arguments:
    <CMD>                       The one command
    <SUB_CMD>                   The ONE_SUB command
```

## 模块

one.bash 使用模块来管理脚本。

用户可以使用 `one` 命令来管理模块。按需启用或禁用模块。

模块有三种类型：`alias`, `completion`, `plugin`。

- 所有 plugins 放在每个 repo 的 `plugins/` 目录。
- 所有 completions 放在每个 repo 的 `completions/` 目录。
- 所有 aliases 放在每个 repo 的 `aliases/` 目录。
- 所有启用的模块会在 `$ONE_DIR/enabled/` 目录下创建软链接。
  - 使用 `one enabled list` 可以查询启用的模块。
  - 使用 `one enabled backup` 备份启动的模块。
- 使用 `one help <mod_type>` 显示使用方法。
- `one <mod_type> enable` 来启用模块。
- `one <mod_type> disable` 来禁用模块。
- `one <mod_type> list` 列出所有模块。

[one.share][] 提供了许多模块、配置、ONE_SUB 命令，以及 bin 命令。

推荐你把 shell 代码移到模块里管理。

详见[模块文档](./docs/advanced-usage/module.md)。

## ONE_REPOS

one.bash 只是一个管理框架。它不包含任何配置文件。
推荐使用官方的 REPO [one.share][]，它提供了很多配置来增强 shell 体验。

one.bash 默认启用 [one.share][] 和 [bash-it][] 。
你可以通过`ONE_SHARE_ENABLE=false` 和 `ONE_BASH_IT_ENABLE=false` 在 `ONE_CONF` 中禁用它们。

你可以创建你自己的 ONE REPO。阅读 [Create Repo](./docs/advanced-usage/repo.md#create-repo) 了解详情。

只需将 REPO 的文件路径添加到 `ONE_REPOS` 中即可启用该 REPO，或从 `ONE_REPOS` 中删除以禁用它。

调用 `one repo l` 来列出当前使用的所有 REPO（根据 `ONE_CONF` 配置）。

## ONE_SUB 命令

放在每个 [REPO](./docs/advanced-usage/repo.md) 的 `sub/` 目录下的可执行文件，都可以使用 `one subs <cmd>` 或 `a <cmd>` 调用。（`$ONE_SUB <cmd>`, `ONE_SUB` 默认值为 `a`，详见 [`ONE_CONF`][one.config.default]）

`sub/` 路径没有包含在 `$PATH`，所有你无法直接调用 ONE_SUB 命令。

详见[文档](./docs/advanced-usage/one-sub-cmd.md)。

## [文档](./docs)

- [Bashrc Initialization Proces](./docs/entry.md)
- [Project File Structure](./docs/file-structure.md)
- [Advanced Usages](./docs/advanced-usage/README.md)
  - [ONE Dependencies](./docs/advanced-usage/dep.md)
  - [ONE Functions](./docs/advanced-usage/one-functions.md)
  - [ONE_SUB Command](./docs/advanced-usage/one-sub-cmd.md)
  - [Fig](./docs/advanced-usage/fig.md)
  - [Bash-it](./docs/advanced-usage/bash-it.md)

## 提建议，修 Bug，做贡献

欢迎提供任何建议或者意见。

**在创建新的 Issue/Discussion/PR，以及发表评论之前**，请先阅读[贡献指南](./docs/CONTRIBUTING.zh.md)。

## 版权声明

Copyright 2022-2023 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

Read the [LICENSE][] file for the specific language governing permissions and limitations under the License.

Read the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## 其他项目

- [lobash](https://github.com/adoyle-h/lobash): 帮助 Bash 脚本开发的现代化、安全、强大的工具库。
- [其他我创建的 shell 项目](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers)


<!-- links -->

[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
[tags]: https://github.com/one-bash/one.bash/tags

<!-- links -->

[one.share]: https://github.com/one-bash/one.share
[one.config.default]: ./one.config.default.bash
[one.links.example.yaml]: https://github.com/one-bash/one.share/blob/master/one.links.example.yaml
[composure]: https://github.com/adoyle-h/composure.git
[dotbot]: https://github.com/anishathalye/dotbot/
[bash-it]: https://github.com/Bash-it/bash-it
[bash-completion]: https://github.com/scop/bash-completion
[Fig]: https://github.com/withfig/fig
[sub]: https://github.com/basecamp/sub
