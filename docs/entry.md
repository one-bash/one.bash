# entry.bash

## Bashrc Initialization Process

It will execute scripts in order:

- ~/.profile or ~/.bash_profile
- ~/.bashrc
- [bash/entry.bash](../bash/entry.bash)
  - Load [exit codes](../bash/exit-codes.bash)
  - Load `$ONE_CONF` (Defaults to $HOME/.config/one.bash/one.config.bash)
  - Load [one.config.default.bash](../one.config.default.bash)
  - Reset PATH: [bash/path.bash](../bash/path.bash)
  - Set XDG environment variables: [bash/xdg.bash](../bash/xdg.bash)
  - If `$ONE_RC` is not empty, enter the `$ONE_RC`, and not execute below steps.
  - If check_shell failed, enter the `$ONE_BASHRC_FO`, and not execute below steps.
  - Load [composure](https://github.com/adoyle-h/composure.git)
  - Load settings for OS.
  - Enable Fig if `$ONE_FIG` is true
  - Enable `one` and `$ONE_SUB` auto-completions. [bash/one-complete.bash](../bash/one-complete.bash)
  - Execute `repo_onload` function if it defined in `one.repo.bash` of each repo.
  - Load [enabled modules](../enabled/) if `ONE_NO_MODS` is false.
