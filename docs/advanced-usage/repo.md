# ONE Repo

## The repos

one.bash is just a management framework. It does not contain any dotfiles, configs.
The official repo [one.share][] and [one-bash-it][] provides them.

## one repo commands

- List all local repos: `one repo list`
- Download and enable repo:
  - `one repo add https://github.com/one-bash/one.share`
  - `one repo add git@github.com:one-bash/one.share.git`
  - `one repo add /local/directory`
- Enable repo: `one repo enable one.share`
- Disable repo: `one repo disable one.share`
- Update repo: `one repo update one.share`
- Remove repo: `one repo remove one.share`
- Create repo: `one repo init`. Read the [Create Repo](#create-repo) for details.
- Execute command in each enabled repo: `one repo exec ls`
- Show the informations of downloaded repo: `one repo info one.share`
- Search repos (topic: one-bash-repo) in Github: `one repo search`

`one repo` for detailed usage.

## Create Repo

`one repo init` to scaffolding a repo.

### File Structure

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
│   └── config-file
├── plugin/
│   └── plugin.bash
├── sub/
│   └── file*
└── one.repo.bash
```

- `file*` must be executable.
- `alias/` stores alias modules.
- `plugin/` stores plugin modules.
- `completion/` stores completion modules.
- `config/` stores dotfile, rcfile and config files.
- `bin/` stores commands. Just like `/usr/local/bin/`. They must be executable.
- `sub/` stores ONE_SUB commands. They must be executable. User can invoke it be `$ONE_SUB <cmd>` and `one sub run <cmd>`. 

### one.repo.bash

The file content:

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
