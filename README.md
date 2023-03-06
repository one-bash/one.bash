<p align="center">
  <img alt="LOGO" src="https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/one.bash/banner.svg">
  <b>Make Bash Great Again!</b>
</p>

An elegant framework to manage commands, completions, dotfiles for bash players.

中文文档 [README.zh.md](./README.zh.md)

## Features

- Manage collections of dotfiles in one place. Using YAML file to manage soft-links via [dotbot][].
- Manage shell scripts, completions, aliases by [modules](#modules). Support custom modules.
- Easy to share and reuse executable files, sub commands, configs and modules by [repo](#onerepos). Read [one.share][].
- Support custom repo and multiple repos. Managed by [`ONE_REPOS`](#onerepos).
- Manage commands under your own scope. Like `a <cmd>` to invoke command that no worry about duplicated in `PATH`. Read the [ONE_SUB Commands](./docs/advanced-usage/one-sub-cmd.md).
- Support custom one.bash. Read [ONE_CONF](#oneconf).
- Support [bash-it][]. You can use `one` commands to manage bash-it's aliases/completions/plugins. Read [bash-it.md](./docs/advanced-usage/bash-it.md).
- Support [Fig][]. Read [fig.md](./docs/advanced-usage/fig.md).

## Environments

- ✅ iTerm2
- ✅ Terminal.app
- ✅ MacOS Intel Arch
- ✅ MacOS ARM Arch
- ✅ Linux/Unix system
- 🚫 Windows system
- 🚫 Zsh. This project is just for Bash players. Zsh players should use [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh).

## CI Status

- [develop branch](https://github.com/one-bash/one.bash/tree/develop): [![CI Status](https://github.com/one-bash/one.bash/actions/workflows/ci.yaml/badge.svg?branch=develop)](https://github.com/one-bash/one.bash/actions/workflows/ci.yaml?query=branch%3Adevelop)

## Versions

See [tags][].
The versions follows the rules of [SemVer 2.0.0](http://semver.org/).

## Dependencies

### Requires

- GNU Bash 4.4 or 5.0+
- [python3](https://www.python.org/)
- [perl 5](https://github.com/Perl/perl5)
- [git](https://github.com/git/git)

## Inspired By

one.bash is inspired by [sub][] and [bash-it][].

- sub: A delicious way to organize programs created by basecamp. But no more maintained.
- bash-it: A community Bash framework.

## Who uses one.bash

See https://github.com/topics/one-bash

( You can add `one-bash` topic in your Github project for sharing. )

## Installation

```sh
# Set the directory for download one.bash
ONE_DIR=~/.one.bash
git clone --depth 1 https://github.com/one-bash/one.bash.git $ONE_DIR
# Note: you should ensure /usr/local/bin/ is in environment variable PATH
sudo ln -s "$ONE_DIR/bin/one" /usr/local/bin/one

# Install Dependencies
one dep install

# Add one.bash to your bashrc. Or you can add the result of "one --bashrc" to bashrc by manual.
echo '' >> ~/.bashrc
one --bashrc >> ~/.bashrc
```

## Configuration

### ONE_CONF

`ONE_CONF` is the filepath of one.bash configuration.
The file is not required. one.bash has [default config](./one.config.default.bash).

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

For more `ONE_CONF` options and documents, Please read [./one.config.default.bash][one.config.default].

You can use `one config <key>=<val>` set config option. (function and array are not supported)

And `one config <key>` to query config option.

### ONE_LINKS_CONF

`ONE_LINKS_CONF` is a bash function that returns a filepath of [dotbot][] config. Defaults to empty.

This function receives two parameters: OS (`uname -s`), Arch (`uname -m`).
It is used for managing different [dotbot][] configs for different environments (such as MacOS and Linux).

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

The [dotbot][] is a tool to manage symbol links of dotfiles and any other files. It is a part of one.bash.
You can use it to create symbol links to any files.

There is a dotbot config template in [one.share][]. You can copy [one.links.example.yaml][] to your directory.

```sh
cp "$ONE_SHARE_DIR"/one.links.example.yaml "$DOTFILES_DIR"/one.links.yaml
# Edit the one.links.yaml for your demand
$EDITOR "$DOTFILES_DIR"/one.links.yaml
```

Invoke `one link` to create symbol links based on ONE_LINKS_CONF file.
**Notice: Do not invoke `one link` with sudo.**

Invoke `one unlink` to remove all symbol links based on ONE_LINKS_CONF file.

You can use [dotbot plugins](https://github.com/anishathalye/dotbot#plugins) for more directives.
See https://github.com/anishathalye/dotbot/wiki/Plugins

## Usage

If `ONE_SHARE_ENABLE` is true, invoke `$ONE_SHARE_ENABLE/recommended-modules` to enable recommended modules in one.share.

If `ONE_BASH_IT_ENABLE` is true, invoke `one completion enable aliases.completion`.

## ONE Commands

The `one` command is used to manage one.bash modules, one.config, and dependencies.

Invoke `one` to show usage of it.

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

It provides many commands defined in [./one-cmds/](./one-cmds).

- `one commands` to list all commands.
- `one help -a` to list all usages of commands.
- `one bin list` to show all executable files in `bin/` of each repo.
- `one sub list` to show all commands in `sub/` of each repo.

## Modules

one.bash uses modules to manage shell scripts.

User can use `one` commands to manage modules. Enable/Disable modules on your demand.

The modules have three types: `alias`, `completion`, `plugin`.

- All plugins are put in `plugins/` of each repo.
- All completions are put in `completions/` of each repo.
- All aliases are put in `aliases/` of each repo.
- All enabled modules are symbol linked in `$ONE_DIR/enabled/` directory.
  - `one enabled list` to view enabled modules.
  - `one enabled backup` to backup enabled modules to a file.
- Read `one help <mod_type>` for usages.
- `one <mod_type> enable` to enable modules.
- `one <mod_type> disable` to disable modules.
- `one <mod_type> list` to list modules.

[one.share][] has provided many modules, configs, ONE_SUB commands, and bin commands.

It's suggested to move your shell codes to modules for management.

Read the [Module document](./docs/advanced-usage/module.md) for details.

## ONE_REPOS

one.bash is just a management framework. It does not contain any dotfiles, configs.
The official repo [one.share][] provides them to enhance shell.

one.bash enable [one.share][] and [bash-it][] by default.
You can disable them by `ONE_SHARE_ENABLE=false` and `ONE_BASH_IT_ENABLE=false` in `ONE_CONF`.

You can create your own ONE repo. Read the [Create Repo](./docs/advanced-usage/repo.md#create-repo) for details.

Just add repo's filepath to `ONE_REPOS` to enable the repo, or remove from `ONE_REPOS` to disable it.

Invoke `one repo l` to list ONE repos based on `ONE_CONF`.

## ONE_SUB Commands

All executable files in `sub/` of each [repo](./docs/advanced-usage/repo.md) could be invoked
by `one subs <cmd>` or `a <cmd>` (`$ONE_SUB <cmd>`, `ONE_SUB` defaults to `a`, read the usage in [`ONE_CONF`][one.config.default]).

The `sub/` path is not included in `$PATH`. So you cannot invoke ONE_SUB commands directly.

Read [this document](./docs/advanced-usage/one-sub-cmd.md) for more details.

## [Docs](./docs)

- [Bashrc Initialization Proces](./docs/entry.md)
- [Project File Structure](./docs/file-structure.md)
- [Advanced Usages](./docs/advanced-usage/README.md)
  - [ONE Dependencies](./docs/advanced-usage/dep.md)
  - [ONE Functions](./docs/advanced-usage/one-functions.md)
  - [ONE_SUB Command](./docs/advanced-usage/one-sub-cmd.md)
  - [Fig](./docs/advanced-usage/fig.md)
  - [Bash-it](./docs/advanced-usage/bash-it.md)

## Suggestion, Bug Reporting, Contributing

Any comments and suggestions are always welcome.

**Before open an issue/discussion/PR, You should search related issues/discussions/PRs first** for avoiding to create duplicated links.

- For new feature request, open a [discussion][], describe your demand concisely and clearly.
- For new feature submit, open a [PR][], describe your demand and design concisely and clearly.
- For bug report, open an [issue][], describe the bug concisely and clearly.
- For bug fix, open a [PR][], concisely and clearly describe what you fixed.
- For question and suggestion, open a [discussion][].
- For anything not mentioned above, open a [discussion][].

Do not post duplicated and useless contents like `+1`, `LOL`. React to comments with emoji instead of.

你可以使用中文反馈意见。但希望你尽可能使用英文，不要中英文混杂，而是完全的英文语句。
因为我们处于国际社区，英文更通用，方便外国人阅读理解你的意见。
(Please communicate in English as much as possible)

Please read [./docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md) before make a Pull Request.

## Copyright and License

Copyright 2022-2023 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

Read the [LICENSE][] file for the specific language governing permissions and limitations under the License.

Read the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## Other Projects

- [lobash](https://github.com/adoyle-h/lobash): A modern, safe, powerful utility/library for Bash script development.
- [Other shell projects created by me](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers)


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
