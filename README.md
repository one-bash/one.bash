<p align="center">
  <img alt="LOGO" src="https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/one.bash/banner.svg">
  <b>Make Bash Great Again!</b>
</p>

A modular framework that manages commands, completions, dotfiles for bash users.

[English](./README.md) | [中文](./README.zh.md)

## Features

- Links: Manage collections of dotfiles in one place. Using `one link` and `one unlink` based on YAML files to manage soft-links. See [ONE Links](./docs/advanced-usage/links.md) for details.
- Modules: Manage shell scripts, completions, aliases, commands (bins), sub-commands (subs) by [modules][one-module]. Support custom modules.
- Repo: Package shell scripts, completions, aliases, commands by [repo][one-repo] for sharing and reusing. Support custom repo and multiple repos.
- Sub-commands: Manage commands under your own scope. Like `a <cmd>` to invoke command that no worry about duplicated in `PATH`. Read the [ONE_SUB Commands][one-sub].
- Configurable one.bash: Read [ONE_CONF](#oneconf).
- Support [bash-it][] via [one-bash-it][]: You can use all aliases/completions/plugins from [bash-it][] via `one` command.

## Environments

- ✅ iTerm2
- ✅ Terminal.app
- ✅ MacOS 13 and above (Intel/ARM Arch)
- ✅ Linux/Unix system
- 🚫 Windows system
- 🚫 Zsh. This project is just for Bash users. Zsh players should use [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh).

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

### Notice

1. After enable or disable any module, it is required to restart the current shell for changes to take effect.
2. When shell has any critical issue and failed to start up, edit your [ONE_CONF](#oneconf) file via `one config --edit`. And set `ONE_RC=<path-to-your-rcfile>` to change bashrc for rescue.

### one link

Create a yaml file at `$HOME/.config/one.bash/one.links.yaml`.

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

Invoke `one link` to create soft-link files.

## [Configuration](./docs/advanced-usage/config.md)

## [Documents](./docs)

- [Bashrc Initialization Proces](./docs/develop/entry.md)
- [Module][one-module]
- [One Repo][one-repo]
- [ONE_SUB Commands](./docs/advanced-usage/one-sub-cmd.md)
- [ONE Links](./docs/advanced-usage/links.md)
- [ONE Dependencies](./docs/advanced-usage/dep.md)
- [ONE Functions](./docs/advanced-usage/one-functions.md)
- [Project File Structure](./docs/develop/project-structure.md)

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

Desc: A modular framework that manages commands, completions, dotfiles for bash users.

Source Code: https://github.com/one-bash/one.bash

Arguments:
    <CMD>                       The one command
    <SUB_CMD>                   The ONE_SUB command
```

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
[composure]: https://github.com/adoyle-h/composure.git
[dotbot]: https://github.com/anishathalye/dotbot/
[bash-it]: https://github.com/Bash-it/bash-it
[bash-completion]: https://github.com/scop/bash-completion
[sub]: https://github.com/basecamp/sub
[one-repo]: ./docs/advanced-usage/repo.md
[one-module]: ./docs/advanced-usage/module.md
[one-sub]: ./docs/advanced-usage/one-sub-cmd.md
