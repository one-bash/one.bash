<p align="center">
  <img alt="LOGO" src="https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/one.bash/banner.svg">
  <b>Make Bash Great Again!</b>
</p>

一个优雅管理命令、shell 脚本，自动补全、配置的框架，适合 bash 玩家。

English Document [README.md](./README.md)

## 功能

- 集中管理一系列配置文件。使用 YAML 文件通过 [dotbot][] 来管理软链接。
- 通过[模块](#模块)管理 shell 脚本、补语、别名。支持自定义模块。
- 通过 [repo](#onerepos) 轻松分享和重用可执行文件、子命令、配置和模块。请阅读 [one.share][]。
- 支持自定义 repo 和多个 repo。由 [`ONE_REPOS`](#onerepos) 管理。
- 可以在一个作用域下管理自己的命令。如 `a <cmd>` 来调用命令，避免在 `PATH` 中重复命令。请阅读 [ONE_SUB Commands](./docs/advanced-usage/one-sub-cmd.md)。
- 支持 one.bash 配置。阅读 [ONE_CONF](#oneconf)。
- 支持 [bash-it][]。你可以使用 one 命令来管理 bash-it 的 aliases/completions/plugins。请阅读 [bash-it.md](./docs/advanced-usage/bash-it.md)。
- 支持 [Fig][]。请阅读 [fig.md](./docs/advanced-usage/fig.md)。

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

`ONE_LINKS_CONF` 是一个 Bash 函数，它返回 [dotbot][] 配置的文件路径。
该函数接收一个参数，值为当前系统的标识。这样你可以管理不同系统下的不同 ONE_LINKS_CONF（比如 MacOS, Linux）

[dotbot][] 通过软链接管理配置文件（或者任何文件）。
你可以使用 [one.share 里的配置文件][one.share] 或者使用你自己的。

默认的 `ONE_LINKS_CONF` 为空。用户需要在 ONE_CONF 文件里定义你自己的文件路径。

```sh
# User should print the path of ONE_LINKS_CONF file
# @param os type
ONE_LINKS_CONF() {
  case "$1" in
    MacOS) echo "$DOTFILES_DIR"/links/macos.yaml ;;
    Linux) echo "$DOTFILES_DIR"/links/debian.yaml ;;
  esac
}
```

你可以从 [one.share][] 拷贝 [one.links.example.yaml][] 到你的目录。

```sh
cp "$ONE_SHARE_DIR"/one.links.example.yaml "$DOTFILES_DIR"/one.links.yaml
# Edit the one.links.yaml for your demand
$EDITOR "$DOTFILES_DIR"/one.links.yaml
```

调用 `one link` 会根据 ONE_LINKS_CONF 创建软链接。
**Notice: 不要用 sudo 调用 `one link`。**

调用 `one unlink` 会根据 ONE_LINKS_CONF 移除目标软链接文件。

你可以使用 [dotbot 插件](https://github.com/anishathalye/dotbot#plugins) 来获得更多指令。
详见 https://github.com/anishathalye/dotbot/wiki/Plugins

## 用法

如果 `ONE_SHARE_ENABLE` 为 true，调用 `$ONE_SHARE_ENABLE/recommended-modules` 来启动 one.share 推荐的模块。

如果 `ONE_BASH_IT_ENABLE` 为 true，调用 `one completion enable aliases.completion`。

## ONE 命令

`one` 命令用来管理 one.bash 模块、配置以及依赖。

调用 `one` 会显示用法。

```
Usage: one [<CMD>]                 Run one command
       one subs [<SUB_CMD>]        Run ONE_SUB command
       one help [<CMD>]            Show the usage of one command
       one help-sub [<SUB_CMD>]    Show the usage of ONE_SUB command
       one [--bashrc]              Print one.bash entry codes for bashrc
       one [-h|--help]             Show the usage of one

Desc: An elegant framework to manage commands, completions, dotfiles for terminal players.
      https://github.com/one-bash/one.bash

Arguments:
  <CMD> the command of one
  <SUB_CMD> the command of ONE_SUB
```

`one` 命令定义在 [./one-cmds/](./one-cmds)。

- `one commands` 列出所有命令。
- `one help -a` 列出所有命令的使用帮助。
- `one bin list` 列出所有 repo 的 `bin/` 目录下的可执行命令。
- `one sub list` 列出所有 repo 的 `sub/` 目录下的可执行命令。

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

**在开 issue/discussion/PR 之前，你必须先搜索相关 [issue][]/[discussion][]/[PR][]**，避免创建重复的链接。

- 请求新功能。请开一个 [discussion][]，简短且清晰地描述你的需求。
- 提交新功能。请开一个 [PR][]，简短且清晰地描述你的需求和设计。
- 报告 BUG。请开一个 [issue][]，简短且清晰地描述你发现的问题。
- 修复 BUG。请开一个 [PR][]，简短且清晰地描述你修了什么。
- 提问和建议。请开一个 [discussion][]。
- 其他上面未提到的内容，请开一个 [discussion][] 来讨论。

不要发重复或无用的内容，比如 `+1`，`哈哈`。请贴 emoji 标签反馈到评论上。

你可以使用中文反馈意见。但希望你尽可能使用英文，不要中英文混杂，而是写下完整的英文语句。
因为我们处于国际社区，英文更通用，方便外国人阅读理解你的意见。

请阅读[如何为本项目贡献](./docs/CONTRIBUTING.md)。

## 版权声明

Copyright 2022 ADoyle (adoyle.h@gmail.com) Some Rights Reserved.
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
[issue]: https://github.com/one-bash/one.bash/issues
[discussion]: https://github.com/one-bash/one.bash/discussions
[PR]: https://github.com/one-bash/one.bash/pulls

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
