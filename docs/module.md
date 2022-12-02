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

It's suggested to move your shell codes to modules.
Read the [Module document](./module.md) and [Custom](../README.md#custom) for details.

[one.share][] has provided many modules, configs, sub commands, and bin commands.

## Write a module

All modules must be put in one of aliases/completions/plugins folders. And its filename must be suffixed with `.bash`.

### Module Template

```sh
# ONE_LOAD_PRIORITY: 400
about-plugin 'Module Description'

# put your shellscript codes here
```

Invoke `one <mod_type> enable <name>` and restart shell to enable the module.


<!-- links -->

[one.share]: https://github.com/one-bash/one.share
