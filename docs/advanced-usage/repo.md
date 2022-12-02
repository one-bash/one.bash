# ONE Repo

one.bash is just a management framework. It does not contain any dotfiles, configs.
I have created [one.share][] (an official repo) to enhance shell.

one.bash enable [one.share][] (an official repo) and [bash-it][] (not one.bash official repo) by default.
You can disable them by `ONE_SHARE_ENABLE=false` and `ONE_BASH_IT_ENABLE=false` in `ONE_CONF`.

You can create your own ONE repo. Read the [Create Repo](#create-repo).

Just add repo's filepath to `ONE_REPOS` to enable the repo, or remove from `ONE_REPOS` to disable it.

Invoke `one repo l` to list ONE repos based on `ONE_CONF`.

## File Structure

A ONE Repo's file structure should be that.

```
.
├── aliases/
│   └── alias.bash
├── bin/
│   └── file*
├── completions/
│   └── cmp.bash
├── configs/
│   └── config
├── plugins/
│   └── plugin.bash
└── sub/
    └── file*
```

- `file*` must be executable.
- `aliases/` stores alias modules.
- `plugins/` stores plugin modules.
- `completion/` stores completion modules.
- `configs/` stores dotfile, rcfile and config files.
- `bin/` stores user commands. Just like `/usr/local/bin/`. They must be executable. The path of bin has been added to `$PATH`.
- `sub/` stores ONE_SUB commands. User can invoke it be `$ONE_SUB <cmd>` and `one subs <cmd>`. They must be executable.

## Create Repo

`one repo init` to scaffolding a repo.

`one help repo` for usage.

<!-- links -->

[one.share]: https://github.com/one-bash/one.share
[bash-it]: https://github.com/Bash-it/bash-it
