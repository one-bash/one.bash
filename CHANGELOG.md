# Changelog

All notable changes to this project will be documented in this file.

The format is inspired by [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/).

The versions follow the rules of [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

[Full Changes](https://github.com/one-bash/one.bash/compare/v0.0.1...HEAD)


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
