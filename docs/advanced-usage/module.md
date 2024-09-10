# Module

one.bash uses modules to manage shell scripts.

User can use `one` commands to manage modules. Enable/Disable modules on your demand.

The modules have three types: `alias`, `completion`, `plugin`.

- All plugins are put in `plugin/` of each repo.
- All completions are put in `completion/` of each repo.
- All aliases are put in `alias/` of each repo.
- All enabled modules are symbol linked in `$ONE_DIR/enabled/` directory.
  - `one enabled` to view enabled modules.
  - `one backup` to backup enabled modules to a file.
- Read `one help <mod_type>` for usages.
- `one <mod_type> enable` to enable modules.
- `one <mod_type> disable` to disable modules.
- `one <mod_type> list` to list modules.

[one.share][] has provided many modules, configs, ONE_SUB commands, and bin commands.

It's suggested to move your shell codes to modules.

## Write a module

All modules must be put in one of alias/completion/plugin folders. And its filename must be suffixed with `.bash` or `.opt.bash`.

### Template of module.bash

```sh
about-plugin 'Module Description'

# put your shellscript codes here
```

Invoke `one <mod_type> enable <name>` and restart shell to enable the module.

### Template of module.opt.bash

For plugin,

```sh
ABOUT='Description of module'

PRIORITY=400

# URL can be a git protocal or http(s) resource url
URL='https://github.com/akinomyoga/ble.sh.git'

# To run command when `one <mod> enable`
RUN='make -C "$MOD_DATA_DIR/git" install PREFIX="$MOD_DATA_DIR/dist"'

# After "RUN" finish, then execute APPEND. The stdout will append to module content.
APPEND='cat <<EOF
. $MOD_DATA_DIR/dist/share/blesh/ble.sh &> "\$(tty)"
EOF'

# Execute INSERT before "RUN" start. The stdout will insert to module content.
# INSERT=""

# To check commands in host when `one <mod> enable`.
# The DEP_CMDS is a string which includes one or more command names separated with spaces.
DEP_CMDS='gawk'

# If URL is omit, you may set an install() function to download the module requirements.
# Download files to MOD_DATA_DIR directory.
# install() {
#   curl -o "$MOD_DATA_DIR"/file "http://..."
# }
```

or

```sh
IFS='' # for multi-line string
ABOUT='Tab completion using fzf. https://github.com/lincheney/fzf-tab-completion'
URL=https://github.com/lincheney/fzf-tab-completion.git
# The `git/` means the downloaded git repo from `URL`.
SCRIPT=git/bash/fzf-bash-completion.sh
PRIORITY=801 # aliases.completion (LOAD_PRIORITY: 800) will reset completion function
APPEND="cat <<EOF
bind -x '\"\\t\": fzf_bash_completion'
_fzf_bash_completion_loading_msg() {
  printf '%b%s \\n' \"\\\${PS1@P}\" \"\\\${READLINE_LINE}\"  | tail -n 1
}
FZF_TAB_OPTS=''
FZF_TAB_TMUX_OPTS='-h ~50% -w ~80%'
EOF"
```

For completion,

```sh
# The URL to download a completion script
URL='https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig.bash'
```

For alias, same to plugin.

### PRIORITY

The modules are loaded by one.bash in order (from lower to higher based on PRIORITY).

This property is optional, each module has default priority.

The value of priority range of each module type:

- `plugin`: 300~499, default 400.
- `completion`: 500~699, default 600.
- `alias`: 700~799, default 750.

For `.bash` file, put `# ONE_LOAD_PRIORITY: <PRIORITY>` at the head of script to set loading priority.

For `.opt.bash` file, put `PRIORITY=<PRIORITY>` in file.

`# ONE_LOAD_PRIORITY: 400` or `PRIORITY=400` means the load priority of module is `400`.


<!-- links -->

[one.share]: https://github.com/one-bash/one.share
