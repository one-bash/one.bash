# ONE Repo

one.bash is just a management framework. It does not contain any dotfiles, configs.
The official repo [one.share][] and [one-bash-it][] provides them to enhance shell.

- List all local repos: `one repo list`
- Download and enable repo:
  - `one repo add https://github.com/one-bash/one.share`
  - `one repo add git@github.com:one-bash/one.share.git`
  - `one repo add /local/directory`
- Enable repo: `one repo enable one.share`
- Disable repo: `one repo disable one.share`
- Update repo: `one repo update one.share`
- Remove repo: `one repo remove one.share`
- Create repo: You can create your own repo. Read the [document](#create-repo) for details.

## File Structure

A ONE Repo's file structure should be that.

```
.
├── alias/
│   └── alias.bash
├── bin/
│   └── file*
├── completion/
│   └── cmp.bash
├── config/
│   └── config
├── plugin/
│   └── plugin.bash
└── sub/
    └── file*
```

- `file*` must be executable.
- `alias/` stores alias modules.
- `plugin/` stores plugin modules.
- `completion/` stores completion modules.
- `config/` stores dotfile, rcfile and config files.
- `bin/` stores user commands. Just like `/usr/local/bin/`. They must be executable. The path of bin has been added to `$PATH`.
- `sub/` stores ONE_SUB commands. User can invoke it be `$ONE_SUB <cmd>` and `one sub run <cmd>`. They must be executable.

## Create Repo

`one repo init` to scaffolding a repo.

`one help repo` for usage.

<!-- links -->

[one.share]: https://github.com/one-bash/one.share
[one-bash-it]: https://github.com/one-bash/one-bash-it
[bash-it]: https://github.com/Bash-it/bash-it
