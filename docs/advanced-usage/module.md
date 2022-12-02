# Module

one.bash uses modules to manage shell scripts.

User can use `one` commands to manage modules. Enable/Disable modules on your demand.

The modules have three types: `alias`, `completion`, `plugin`.

- All plugins are put in `plugins/` of each repo.
- All completions are put in `completions/` of each repo.
- All aliases are put in `aliases/` of each repo.
- All enabled modules are symbol linked in `$ONE_DIR/enabled/` directory.
- Read `one help <mod_type>` for usages.
- `one <mod_type> enable` to enable modules.
- `one <mod_type> disable` to disable modules.
- `one <mod_type> list` to list modules.

[one.share][] has provided many modules, configs, sub commands, and bin commands.

It's suggested to move your shell codes to modules.

## Write a module

All modules must be put in one of aliases/completions/plugins folders. And its filename must be suffixed with `.bash`.

### Module Template

```sh
# ONE_LOAD_PRIORITY: 400
about-plugin 'Module Description'

# put your shellscript codes here
```

Invoke `one <mod_type> enable <name>` and restart shell to enable the module.

### ONE_LOAD_PRIORITY

The modules are loaded by one.bash in order (`ONE_LOAD_PRIORITY` from lower to higher).

Put `# ONE_LOAD_PRIORITY: <PRIORITY>` at the head of script to set loading priority.

`# ONE_LOAD_PRIORITY: 400` means the load priority of module is 400. It is optional, each module has default priority.

The priority range of each module type:

- `plugin`: 300~499, default 400.
- `completion`: 500~699, default 600.
- `alias`: 700~799, default 700.


<!-- links -->

[one.share]: https://github.com/one-bash/one.share
