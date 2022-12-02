# Project File Structure

```
.
├── bash/
│   ├── envs/                       # Different environments
│   │   ├── linux.bash              # Settings for Linux user
│   │   └── mac.bash                # Settings for MacOS user
│   ├── bash_profile                # Link to ~/.bash_profile
│   ├── bashrc                      # Link to ~/.bashrc
│   ├── bashrc.failover.bash        # failover for ~/.bashrc
│   ├── check-environment.bash
│   ├── debug.bash
│   ├── enable-mods.bash
│   ├── entry.bash                  # The entrypoint of one.bash
│   ├── failover.bash
│   ├── helper.bash
│   ├── inputrc                     # Set shortcut Key Character Sequence (keyseq). Link to ~/.inputrc
│   ├── one.bash
│   ├── one-load.bash
│   ├── mod.bash
│   ├── profile                     # Link to ~/.profile
│   ├── sub.bash                    # The entrypoint of SUB command
│   └── xdg.bash                    # Set XDG_ variables
├── one-cmds/                        #
│   ├── backup-enabled*             # Create a restore file for enabled modules
│   ├── bins*                       # List executable files in each REPO/bin
│   ├── commands*                   # List one commands
│   ├── debug*                      # Toggle debug mode on one.bash
│   ├── disable*                    # Disable modules
│   ├── enable*                     # Enable modules
│   ├── help*                       # Print the usage of one.bash sub command
│   ├── install*                    # Install one.bash
│   ├── link*                       # Create soft-links based on dotbot config yaml
│   ├── list*                       # List modules
│   └── unlink*                     # Remove soft-links based on dotbot config yaml
├── sub/                            # ONE_SUB Commands
├── deps/                           # Dependencies
│   ├── composure/
│   ├── dotbot/                     # https://github.com/anishathalye/dotbot
│   ├── colors.bash
│   ├── one_l.bash                  # Similar to lobash.bash. Just less functions for one.bash.
│   └── lobash.bash                 # https://github.com/adoyle-h/lobash
├── docs/                           # The documents of this project
├── enabled/                        # Enabled modules. soft-link files
├── README.md
├── .ignore                         # Ignore files for rg and ag
└── one.config.default.bash         # ONE.bash default config
```
