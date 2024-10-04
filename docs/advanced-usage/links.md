# One Links

Using `one link` and `one unlink` based on YAML files to manage soft-links.

The YAML filepath defaults to `$HOME/.config/one.bash/one.links.yaml`.
User can change the filepath by setting config option `ONE_LINKS_CONF`.

## ONE_LINKS_CONF

`ONE_LINKS_CONF` can be a string, an array of strings, and a function. The default value is `$ONE_CONF_DIR/one.links.yaml`.

The `one link` and `one unlink` commands read the contents of the `ONE_LINKS_CONF` file to manage symbolic links.
**Notice: Do not invoke `one link` and `one unlink` with sudo.**

The contents of the `ONE_LINKS_CONF` file uses the [dotbot configuration](https://github.com/anishathalye/dotbot#configuration).

There is a dotbot config template [one.links.example.yaml][]. You can copy its content to `one.links.yaml`.

<!-- You can use [dotbot plugins](https://github.com/anishathalye/dotbot#plugins) for more directives. -->
<!-- See https://github.com/anishathalye/dotbot/wiki/Plugins -->

### ONE_LINKS_CONF Array

It can be used to manage multiple ONE_LINKS_CONF files for splitting and reuse.

```sh
ONE_LINKS_CONF=("/a/one.links.yaml" "/b/one.lins.yaml")
```

### ONE_LINKS_CONF Function

`ONE_LINKS_CONF` can be a Bash function that returns a filepath of [dotbot][] config. Defaults to empty.

This function receives two parameters: OS (`uname -s`), Arch (`uname -m`).The ONE_LINKS_CONF path must be returned with `echo`.

It is used for managing different [dotbot][] configs for different environments (such as MacOS and Linux).

```bash
# User should print the filepath of ONE_LINKS_CONF
# User can print multiple filepaths
# @param os   $(uname -s)
# @param arch $(uname -m)
ONE_LINKS_CONF() {
  local os=$1
  local arch=$2
  case "$os_$arch" in
    Darwin_arm64)
      echo "$DOTFILES_DIR"/links/macos_common.yaml
      echo "$DOTFILES_DIR"/links/macos_arm.yaml
      ;;
    Darwin_amd64)
      echo "$DOTFILES_DIR"/links/macos_common.yaml
      echo "$DOTFILES_DIR"/links/macos_intel.yaml
      ;;
    Linux*) echo "$DOTFILES_DIR"/links/linux.yaml ;;
  esac
}
```

## Dotbot Plugins

User can use `one dotbot-plugin add` to add [dotbot plugin](https://github.com/anishathalye/dotbot/wiki/Plugins).

For example, using the https://github.com/DrDynamic/dotbot-git

Run `one dotbot-plugin add DrDynamic/dotbot-git`

Edit the `ONE_LINKS_CONF` file:

```yaml
- git:
    '~/.oh-my-zsh/custom/plugins/zsh-autosuggestions':
        url: 'https://github.com/zsh-users/zsh-autosuggestions'
        description: 'oh my zsh - autosuggestions'
    '~/.oh-my-zsh/custom/themes/powerlevel10k':
        url: 'https://github.com/romkatv/powerlevel10k.git'
        description: 'oh my zsh - powerlevel10k'
    '~/.zprezto':
        url: 'https://github.com/sorin-ionescu/prezto.git'
        description: "Install zprezto"
        recursive: true
```

Run `one link`


[one.links.example.yaml]: https://github.com/one-bash/one.share/blob/master/one.links.example.yaml
[dotbot]: https://github.com/anishathalye/dotbot/
