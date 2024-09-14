<p align="center">
  <img alt="LOGO" src="https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/one.bash/banner.svg">
  <b>Make Bash Great Again!</b>
</p>

An elegant framework to manage commands, completions, dotfiles for bash players.

[English](./README.md) | [中文](./README.zh.md)

## Features

- Manage collections of dotfiles in one place. Using YAML file to manage soft-links via [dotbot][].
- Manage shell scripts, completions, aliases by [modules][one-module]. Support custom modules.
- Easy to share and reuse executable files, sub commands, configs and modules by [repo][one-repo]. Support custom repo and multiple repos.
- Manage commands under your own scope. Like `a <cmd>` to invoke command that no worry about duplicated in `PATH`. Read the [ONE_SUB Commands][one-sub].
- Configurable one.bash. Read [ONE_CONF](#oneconf).
- Support [bash-it][] via [one-bash-it][]. You can use `one` commands to manage bash-it's aliases/completions/plugins. Read [bash-it.md](./docs/advanced-usage/bash-it.md).

## Environments

- ✅ iTerm2
- ✅ Terminal.app
- ✅ MacOS 13 and above (Intel/ARM Arch)
- ✅ Linux/Unix system
- 🚫 Windows system
- 🚫 Zsh. This project is just for Bash players. Zsh players should use [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh).

## Versions

See [releases][].
The versions follows the rules of [SemVer 2.0.0](http://semver.org/).

## Requires

- GNU Bash 4.4 or 5.0+
- [python3](https://www.python.org/)
- [perl 5](https://github.com/Perl/perl5)
- [git](https://github.com/git/git)
- sed, awk, grep, find

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

## Upgrade

```sh
# upgrade one.bash and its dependencies to latest version
one upgrade
# check the status of all dependencies
one dep status
```

## Quick Start

```bash
# Add a repo
one repo add one-bash/one.share
one repo add Bash-it/bash-it

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

If shell has any critical issue and failed to start up, try `ONE_RC=<path-to-your-rcfile>` to change bashrc for rescue.

## Configuration

### ONE_CONF

`ONE_CONF` is the filepath of one.bash configuration.
The file is not required. one.bash has [default config](./one.config.default.bash).

```bash
ONE_CONF=${XDG_CONFIG_HOME:-$HOME/.config}/one.bash/one.config.bash
mkdir -p "$(dirname "$ONE_CONF")"

# Create your dotfiles on any path.
DOTFILES_DIR=$HOME/.dotfiles
mkdir -p "$DOTFILES_DIR"

cat <<-EOF >"$ONE_CONF"
DOTFILES_DIR="$DOTFILES_DIR"

ONE_DEBUG=false
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

### ONE_DIR

`ONE_DIR` is the directory where the one.bash located. This is a constant and does not need user to set.

### ONE_CONF_DIR

`ONE_CONF_DIR` is the directory where the ONE_CONF file located. This is a constant and does not need user to set.

### ONE_LINKS_CONF

`ONE_LINKS_CONF` can be a string, an array of strings, and a function. The default value is `$ONE_CONF_DIR/one.links.yaml`.

The `one link` and `one unlink` commands read the contents of the `ONE_LINKS_CONF` file to manage symbolic links.
**Notice: Do not invoke `one link` and `one unlink` with sudo.**

The contents of the `ONE_LINKS_CONF` file uses the [dotbot configuration](https://github.com/anishathalye/dotbot#configuration).

There is a dotbot config template [one.links.example.yaml][]. You can copy its content to `one.links.yaml`.

<!-- You can use [dotbot plugins](https://github.com/anishathalye/dotbot#plugins) for more directives. -->
<!-- See https://github.com/anishathalye/dotbot/wiki/Plugins -->

#### ONE_LINKS_CONF Array

It can be used to manage multiple ONE_LINKS_CONF files for splitting and reuse.

```sh
ONE_LINKS_CONF=("/a/one.links.yaml" "/b/one.lins.yaml")
```

#### ONE_LINKS_CONF Function

`ONE_LINKS_CONF` can be a Bash function that returns a filepath of [dotbot][] config. Defaults to empty.

This function receives two parameters: OS (`uname -s`), Arch (`uname -m`).The ONE_LINKS_CONF path must be returned with `echo`.

It is used for managing different [dotbot][] configs for different environments (such as MacOS and Linux).

```bash
# User should print the filepath of ONE_LINKS_CONF
# User can print multiple filepaths
# @param os   $(uname -s)
# @param arch $(uname -m)
ONE_LINKS_CONF() {
  local os=$1
  local arch=$2
  case "$os_$arch" in
    Darwin_arm64)
      echo "$DOTFILES_DIR"/links/macos_common.yaml
      echo "$DOTFILES_DIR"/links/macos_arm.yaml
      ;;
    Darwin_amd64)
      echo "$DOTFILES_DIR"/links/macos_common.yaml
      echo "$DOTFILES_DIR"/links/macos_intel.yaml
      ;;
    Linux*) echo "$DOTFILES_DIR"/links/linux.yaml ;;
  esac
}
```

## Usage

The `one` command is used to manage one.bash [repos][one-repo] and [modules][one-module], one.config, and dependencies.

```bash
# Enter "one" to show the usage.
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

Desc:
    An elegant framework to manage commands, completions, dotfiles for terminal players.
    Source code: https://github.com/one-bash/one.bash

Arguments:
    <CMD>                       The one command
    <SUB_CMD>                   The ONE_SUB command
```

## [Documents](./docs)

- [Module][one-module]
- [One Repo]()
- [ONE_SUB Commands](./docs/advanced-usage/one-sub-cmd.md)
- [Bashrc Initialization Proces](./docs/develop/entry.md)
- [Project File Structure](./docs/develop/project-structure.md)
- [Advanced Usages](./docs/advanced-usage/README.md)
  - [ONE Dependencies](./docs/advanced-usage/dep.md)
  - [ONE Functions](./docs/advanced-usage/one-functions.md)
  - [ONE_SUB Command](./docs/advanced-usage/one-sub-cmd.md)
  - [Bash-it](./docs/advanced-usage/bash-it.md)

## Suggestion, Bug Reporting, Contributing

Any comments and suggestions are always welcome.

**Before opening new Issue/Discussion/PR and posting any comments**, please read [CONTRIBUTING.md](./docs/CONTRIBUTING.md).

## Copyright and License

Copyright 2022-2024 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

Read the [LICENSE][] file for the specific language governing permissions and limitations under the License.

Read the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## Other Projects

- [lobash](https://github.com/adoyle-h/lobash): A modern, safe, powerful utility/library for Bash script development.
- [Other shell projects created by me](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers)


<!-- links -->

[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
[releases]: https://github.com/one-bash/one.bash/releases

<!-- links -->

[one.share]: https://github.com/one-bash/one.share
[one-bash-it]: https://github.com/one-bash/one-bash-it
[one.config.default]: ./one.config.default.bash
[one.links.example.yaml]: https://github.com/one-bash/one.share/blob/master/one.links.example.yaml
[composure]: https://github.com/adoyle-h/composure.git
[dotbot]: https://github.com/anishathalye/dotbot/
[bash-it]: https://github.com/Bash-it/bash-it
[bash-completion]: https://github.com/scop/bash-completion
[sub]: https://github.com/basecamp/sub
[one-repo]: ./docs/advanced-usage/repo.md
[one-module]: ./docs/advanced-usage/module.md
[one-sub]: ./docs/advanced-usage/one-sub-cmd.md
