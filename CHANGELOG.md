# Changelog

All notable changes to this project will be documented in this file.

The format is inspired by [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/).

The versions follow the rules of [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.6.0...HEAD)


<a name="v0.6.0"></a>
## v0.6.0 (2024-10-03 04:01:58 +08:00)

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.5.0...v0.6.0)

### New Features

- add hooks: BEFORE_ENABLE and BEFORE_DISABLE ([0687c74](https://github.com/one-bash/one.bash/commit/0687c749cc5688e7a146b2e47040ce30075ec95d))
- add command "one doc" to query documentations ([00e770d](https://github.com/one-bash/one.bash/commit/00e770d579881beac82fd7d3064ca235526949c1))

### Bug Fixes

- "one plugin info" not print PRIORITY for plugin.opt.bash ([fdcbae7](https://github.com/one-bash/one.bash/commit/fdcbae735a85c7bf10a31edb4becd7ba27b9c6e1))
  > And add color for PRIORITY printed
- DEPS must be string (one command), or an array (multi commands) ([32c4366](https://github.com/one-bash/one.bash/commit/32c43667b100de8bbbedb1fff2925a5cbf13a73d))

### Document Changes

- Enable module with variables ([7bfd50a](https://github.com/one-bash/one.bash/commit/7bfd50a2c3d7002dc33f000fcf69beb3019b3e36))


<a name="v0.5.0"></a>
## v0.5.0 (2024-09-22 18:04:11 +08:00)

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.4.0...v0.5.0)

### New Features

- add "shopt -s extdebug" while ONE_DEBUG=true ([d4bf4c8](https://github.com/one-bash/one.bash/commit/d4bf4c874e318f7f949cd9bf4fa15f955ed29110))

### Bug Fixes

- SCRIPT: unbound variable ([6206088](https://github.com/one-bash/one.bash/commit/6206088cce8f918d6e7b6af4527a0da62c4b0179))
- change CWD to MOD_DATA_DIR for AFTER_DOWNLOAD/RUN_AND_INSERT/RUN_AND_APPEND ([dcceecd](https://github.com/one-bash/one.bash/commit/dcceecd996dd68fcff9d807d9b9fa17a286342b5))
- GIT_BRANCH could be undefined ([750b3c5](https://github.com/one-bash/one.bash/commit/750b3c54bf1a3b7b55c17b442a57ddda3123dca6))


<a name="v0.4.0"></a>
## v0.4.0 (2024-09-21 05:07:15 +08:00)

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.3.0...v0.4.0)

### New Features

- mod.opt.bash support GIT_BRANCH ([f9519bc](https://github.com/one-bash/one.bash/commit/f9519bcc91396e4205f60c4d4a9c7d8a57661924))
- mod.opt.bash support property "BIN" ([20b4a12](https://github.com/one-bash/one.bash/commit/20b4a128aabd9bf0ea74c08044a764eb4aee48a9))

### Bug Fixes

- one backup should print repo_name for each mod ([2545573](https://github.com/one-bash/one.bash/commit/25455736bfeff33e71b30d8c77b4754ab2746c0b))
- create meta.bash for bin/sub.opt.bash when "one bin/sub enable" ([3f73c2d](https://github.com/one-bash/one.bash/commit/3f73c2d70b18def665321e1d5149b471921a520f))
- GITHUB_RELEASE_FILES not work ([bb8be7c](https://github.com/one-bash/one.bash/commit/bb8be7cd3dc92706a7bb82ec47cf34cea3849634))
- GIT_REPO instead of GITHUB_REPO ([912b660](https://github.com/one-bash/one.bash/commit/912b6604696f52f9e3ab5c8c9010a84a7e855032))
  > GITHUB_REPO is deprecated and will be removed in v1

### Document Changes

- better docs ([c2d3bb6](https://github.com/one-bash/one.bash/commit/c2d3bb62ce68ca8702e1050d8ebe958b885ba94d))


<a name="v0.3.0"></a>
## v0.3.0 (2024-09-19 15:45:40 +08:00)

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.2.0...v0.3.0)

### New Features

- one enabled show list with pager ([3fdc5c4](https://github.com/one-bash/one.bash/commit/3fdc5c4fffdf7af47ddf639e40e0fe9d635316f7))

### Bug Fixes

- missing enabled folders ([67d1f5a](https://github.com/one-bash/one.bash/commit/67d1f5a255a896b66946bf4e6fbf91099f770fa0))
- remove useless repo_add_pre() function for one.repo.bash ([b8cbcaa](https://github.com/one-bash/one.bash/commit/b8cbcaaa7f77e9828ddfa94836948d79b45288f8))
- cd should not print stderr ([fb225c0](https://github.com/one-bash/one.bash/commit/fb225c0f183a97f04fe596ad9f4fc9c2a812b9de))

### Document Changes

- fix ([655698e](https://github.com/one-bash/one.bash/commit/655698e598a4df020aee48f7b3e5b4f383f549dd))


<a name="v0.2.0"></a>
## v0.2.0 (2024-09-15 12:59:01 +08:00)

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.1.0...v0.2.0)

### Breaking Changes

**⚠️  NOTE: There are huge changes between v0.1 and v0.2.**

Please run `one backup > ./one.backup.bash` before migrating to v0.2.

Check the usage in README.md.

1. `cd $ONE_DIR/enabled` and `rm -rf ./*` to remove all enabled files.
2. Run `one repo add` to add one repos.
3. Run `./one.backup.bash` to recover previous one.bash modules.

### New Features

- big change ([a6b3ce4](https://github.com/one-bash/one.bash/commit/a6b3ce4bd945ac14a1d31d63b50ed1baf54a60ae))
- add "one search `<WORD>`" ([dfa12b9](https://github.com/one-bash/one.bash/commit/dfa12b93c34f75d16eabd6aafdeb551cf393ac4f))
  > "one search -a <WORD>" to search with all added repos.
- support "one bin" ([9b01c0b](https://github.com/one-bash/one.bash/commit/9b01c0bca878da5d0045a45e99055c47af5e48f6))
  > Breaking Changes:
  > 
  > Remove "$ONE_REPO/bin" from PATH env variable. Add "$ONE_DIR/enabled/bin" to PATH.
  > User should use "one bin enable NAME" to create symlinks at "$ONE_DIR/enabled/bin".
- support "one repo" && ONE_BASH_* and ONE_SHARE_* config options are deprecated ([6990c83](https://github.com/one-bash/one.bash/commit/6990c83d3f139136c013bd5cad8fcd153d086eb7))
  > - See the repo usage via "one repo help"
  > - User can custom own repo. Add repo from local path or git host.
  > 
  > Breaking Changes:
  > 
  > - ONE_BASH_* and ONE_SHARE_* options are deprecated. User should remove them from your one.config.bash.
  > - one.bash will not auto install one.share and bash-it.
  >   - Use "one repo add https://github.com/one-bash/one.share" to add one.share repo.
  >   - Use "one repo add https://github.com/one-bash/one-bash-it" to add bash-it repo.
- support "one plugin edit" ([ce8b5c7](https://github.com/one-bash/one.bash/commit/ce8b5c704aa95ba8e12be5c04b414c5d6caa1d10))
- add "one disable-all" ([0f9daea](https://github.com/one-bash/one.bash/commit/0f9daea3e763fc94b757fbe0e5511567192fd278))
- add one_MANPATH_append and one_MANPATH_insert functions ([a2aa141](https://github.com/one-bash/one.bash/commit/a2aa1411c7690e41f5a98c86f0cab1b6b321a26c))
- **one dep**: new command "one dep status" to show status of deps ([7852009](https://github.com/one-bash/one.bash/commit/7852009c3fab6bc4ed94f0e6aba00323b2de8b4d))

### Bug Fixes

- COLOR_ENABLED=yes when $TERM match *-color ([fffa3c8](https://github.com/one-bash/one.bash/commit/fffa3c8ee862fd21b3ca9bdeace2770d2e788dc4))
- "one backup" should backup "bins" and "repos" ([a6b7a91](https://github.com/one-bash/one.bash/commit/a6b7a91f79f25b0910f9877dba32b581e403a624))
- add color to logs ([3ec0acd](https://github.com/one-bash/one.bash/commit/3ec0acd7b1e24ca6741838b24cab9e239b4006ef))
- add usages and completions and fix bugs for one-cmds ([7d9a44e](https://github.com/one-bash/one.bash/commit/7d9a44eeb060468ea1930e9a5739fc1e7a1c9f3a))
- For mod.opt.bash, SCRIPT field can be omitted ([98655f2](https://github.com/one-bash/one.bash/commit/98655f2a2d9525455e30936391c583809fe2b5a1))
-  colorful output and more details for list/info one mods and repos ([3d710de](https://github.com/one-bash/one.bash/commit/3d710deb8c4296a81e4e61e17f5cbc1582672580))
- one help repo && remove colorful output ([b495519](https://github.com/one-bash/one.bash/commit/b4955192e21059e44a4d870b4fa7df9161bd739c))
- log format ([1d29d02](https://github.com/one-bash/one.bash/commit/1d29d026169d60297904ba0313ed1cfe0721fa1e))
- better "one bin" ([6c902ef](https://github.com/one-bash/one.bash/commit/6c902ef4d34bb95dd03d24cd0670f51ba56f3cbf))
- "one sub" should be enabled/disabled by users ([d94d058](https://github.com/one-bash/one.bash/commit/d94d058b610c59d65dcc9e35eaa84257098e4771))
- log_verb and log_info should print to stderr ([4228b11](https://github.com/one-bash/one.bash/commit/4228b11d87ff42b410e12e675a81e683603d4eb5))
- syntax error near unexpected token 'then' ([9bf46e7](https://github.com/one-bash/one.bash/commit/9bf46e712b60ab4e600f018611b4a391701eba3e))
- ⚠️  split "one enabled" command to "one backup" and "one enabled" ([1899e6f](https://github.com/one-bash/one.bash/commit/1899e6f4067a77780efd5483b8e8ef4f0bca6870))
  > Breaking Change:
  > 
  > one enabled list -> one enabled
  > one enabled backup -> one backup
- ONE_LOAD_PRIORITY not work in Linux ([13ea0f2](https://github.com/one-bash/one.bash/commit/13ea0f2c1a2abb55a27bf86e0e92ee73946df231))
- **enable**: if create_mod failed, do not continue ([56bc550](https://github.com/one-bash/one.bash/commit/56bc5504c34f8632217adfedb5a1bfed3d8cf17e))
- **one link**: ONE_ variables not found ([2d8819c](https://github.com/one-bash/one.bash/commit/2d8819c2399d54974abcf81c336a1d152f20301e))
- **one link**: ONE_CONF: unbound variable ([04e4b6e](https://github.com/one-bash/one.bash/commit/04e4b6eab937a785ddabf1e29bce8e89d890c0d8))


<a name="v0.1.0"></a>
## v0.1.0 (2023-03-14 15:17:01 +08:00)

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.0.1...v0.1.0)

### Breaking Changes

Have 1 breaking changes. Check below logs with ⚠️ .

### New Features

- ⚠️  for mod.opt.bash, add new options "DEP_CMDS" "RUN" ([1f5068b](https://github.com/one-bash/one.bash/commit/1f5068b68c3d60219a444afc0bb0c6b3dd0bf951))
  > - DEP_CMDS: to check commands in your host when `one <mod> enable`.
  >   - The DEP_CMDS is a string which includes one or more command names separated with spaces.
  > - RUN: to run command when `one <mod> enable`
  > - The stdout and stderr of RUN/INSERT/APPEND will output to `$ONE_DIR/data/$mod_type/$mod/enable.log` when `one <mod> enable`
  > 
  > Breaking Change:
  > 
  > - If URL suffixed with ".git", it will be downloaded to `$ONE_DIR/data/$mod_type/$mod/git`
  >   - Otherwise, it will be downloaded to `$ONE_DIR/data/$mod_type/$mod/script.bash`
  > - If you use below mods, you should re-enable them via `one <mod> enable` to fix symbol links.
  >   - completions/cheat.opt.bash
  >   - completions/crictl.opt.bash
  >   - completions/ctr.opt.bash
  >   - completions/docker-compose.v1.opt.bash
  >   - completions/docker.opt.bash
  >   - completions/exa.opt.bash
  >   - completions/fzf-tab.opt.bash
  >   - completions/gulp.opt.bash
  >   - completions/helm.opt.bash
  >   - completions/hubble.opt.bash
  >   - completions/minikube.opt.bash
  >   - completions/mvn.opt.bash
  >   - completions/npm.opt.bash
  >   - completions/nvim.opt.bash
  >   - completions/pm2.opt.bash
  >   - completions/procs.opt.bash
  >   - completions/rclone.opt.bash
  >   - completions/yq.opt.bash
  >   - completions/zig.opt.bash
  >   - plugins/ble.opt.bash
  >   - plugins/zoxide.opt.bash
  > - If you has customized mod.opt.bash, please modify the value of `SCRIPT` option
  >   - Before: `SCRIPT=path/script.bash`. Now: `SCRIPT=git/path/script.bash`. The `git/` means the downloaded git repo from `URL`.
- add "one log" and new config option "ONE_LOG_FILE" ([9c2723d](https://github.com/one-bash/one.bash/commit/9c2723ddfebf778edf56b4b7b66ddb8f7147c694))
  > Some one-cmds would print logs to $ONE_LOG_FILE. User can use `one log` to read logs.
  > 
  > User can change the path of ONE_LOG_FILE in one.config.bash. It defaults to `$ONE_DIR/tmp/one.log`.
- support "one config --edit" to edit config file ([5ab9673](https://github.com/one-bash/one.bash/commit/5ab9673fd42b4fa1ebdc8262fd10fc931e6d1aac))

### Document Changes

- update CONTRIBUTING ([a7b96f0](https://github.com/one-bash/one.bash/commit/a7b96f024a5c80ec5166dcab5c54c32a5323a6ae))
- renew License date ([d8eddbd](https://github.com/one-bash/one.bash/commit/d8eddbdd107b7a84e31b8a2674f9dcd08110e91b))


<a name="v0.0.1"></a>
## v0.0.1 (2023-03-06 12:59:07 +08:00)


### Breaking Changes

Have 1 breaking changes. Check below logs with ⚠️ .

### New Features

- add one_PATH_append and one_PATH_insert functions ([48f8313](https://github.com/one-bash/one.bash/commit/48f83136c35e5ef750292e341b8cbff2871d79fe))
- add command "one `<mod>` info" ([175327c](https://github.com/one-bash/one.bash/commit/175327c082824b9b02ed631c8c3f321f70df561b))
- better command usages and completions ([7500d28](https://github.com/one-bash/one.bash/commit/7500d2871c4d0f2496fd309122366403caba07da))
- support `<mod>.opt.bash && "one <mod>` list" prints more details ([63678b4](https://github.com/one-bash/one.bash/commit/63678b4f3c70ff781ada075a6fa1c6b5a974886c))
- move backup-enabled to "one enabled backup" && add "one enabled list" ([5de6223](https://github.com/one-bash/one.bash/commit/5de62236f34371a70c772763be7b04a0dfe7921c))
- better module list && support "one `<mod>` which" command ([162ca15](https://github.com/one-bash/one.bash/commit/162ca15e162a2b4b39cde76e571519a1b7957320))
- add "one sub which" ([e97c4b2](https://github.com/one-bash/one.bash/commit/e97c4b250b2ceb6ccc80fa27972364d2b26db115))

### Bug Fixes

- one_stdout and one_stderr add prefix "[one.bash]" ([7f8b3c5](https://github.com/one-bash/one.bash/commit/7f8b3c59da940323afbe7c79d2feb216c77cec1e))
  > And refactor one_debug printf format
- change alias default priority 800 -> 750 ([ee408e6](https://github.com/one-bash/one.bash/commit/ee408e6331fff2ddbce5e253cd5f801ce7583792))
- update usages && restore-modules should disable all then enable modules ([5d397c5](https://github.com/one-bash/one.bash/commit/5d397c5eacf481006e833f6e96c93d19ad7a2346))
- change option "-a" to "--all" for "one `<mod_type>` disable" ([d998cb0](https://github.com/one-bash/one.bash/commit/d998cb08525210392dbddc6b5d1c23e27ea45557))
  > Because "-a" is not intuitive enough.
- wrong path of ONE_DIR ([d9d025a](https://github.com/one-bash/one.bash/commit/d9d025ab73a7d468644094b1fac38670a9ada296)) ([#1](https://github.com/one-bash/one.bash/issues/1))
  > fix [#1](https://github.com/one-bash/one.bash/issues/1)
- sort the results of "one `<mod>` list" ([a107e6d](https://github.com/one-bash/one.bash/commit/a107e6d14efcb1d12af455c8571a0dc7810b9162))
- add data/user/ to .git && ask to update mod data ([568ecd5](https://github.com/one-bash/one.bash/commit/568ecd59d8427587ae11b14e6cb98d9737585154))
- when ONE_FIG=true and fig command not found, to print error message ([4c09ceb](https://github.com/one-bash/one.bash/commit/4c09ceb4cfbaa7b50280793733acca6d151c4f94))
- support bash-it ([9e21750](https://github.com/one-bash/one.bash/commit/9e217509c14c1ed91636b7c0b32eca524c0b53fb))
- support bash-it complete ([c7d50c5](https://github.com/one-bash/one.bash/commit/c7d50c5803864afa212d28c4e7ff14638de9e115))
- ⚠️  **config**: ONE_LINKS_CONF receive two parameters: os, arch ([d40deb0](https://github.com/one-bash/one.bash/commit/d40deb02dcfa2f4acd916f0845890e72fb6478be))
  > BREAKING CHANGE:
  > 
  > The value of OS changed from "MacOS" to "Darwin"
- **dep**: shell completion of "one dep" should only list git repo ([6656b8e](https://github.com/one-bash/one.bash/commit/6656b8e299d99833b360ce481ef1c972b3fbc56b))
  > to skip one-bash-it folder
- **dep**: create symbol links to bash-it ([599ce12](https://github.com/one-bash/one.bash/commit/599ce126e5480a2c347e848b4019060a612254a9))
- **help**: highlight not found in yellow ([a0fe95a](https://github.com/one-bash/one.bash/commit/a0fe95afeb1df2a186ea9edce7c2b87f4b8156b7))

### Document Changes

- update the usage of one enabled ([ac6f105](https://github.com/one-bash/one.bash/commit/ac6f105d12868cf968b2d5f47941b98496111b74))
- add Chinese documents ([a3097ac](https://github.com/one-bash/one.bash/commit/a3097acc909bc4ef92a98ea524ce127ada83008b))
- improve documents ([a4a60b9](https://github.com/one-bash/one.bash/commit/a4a60b9293fee834359251e0d0322c8a01faf1b7))
- improve documents ([207d2ca](https://github.com/one-bash/one.bash/commit/207d2ca9a533e0c929dc0af025c016bac9299ccf))
- remove useless notice ([e08f37b](https://github.com/one-bash/one.bash/commit/e08f37b31b07ee2081b94c788b8b42b9cd118b21))
