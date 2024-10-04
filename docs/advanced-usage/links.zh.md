# One Links

使用基于 YAML 文件的 `one link` 和 `one unlink` 来管理软链接。

YAML 文件路径默认为 `$HOME/.config/one.bash/one.links.yaml`。
用户可以通过设置配置选项 `ONE_LINKS_CONF` 来更改文件路径。

## ONE_LINKS_CONF

`ONE_LINKS_CONF` 可以是字符串，字符串数组，以及函数。默认值是 `$ONE_CONF_DIR/one.links.yaml`。

`one link` 以及 `one unlink` 命令读取 `ONE_LINKS_CONF` 指向的文件内容，来管理软链接。
**注意: 不要用 sudo 调用 `one link` 和 `one unlink`。**

`ONE_LINKS_CONF` 文件内容采用 [dotbot 配置](https://github.com/anishathalye/dotbot#configuration)。

这有一份提供了 dotbot 配置模板 [one.links.example.yaml][]。你可以拷贝内容到 `one.links.yaml`。

<!-- 你可以使用 [dotbot 插件](https://github.com/anishathalye/dotbot#plugins) 来获得更多指令。 -->
<!-- 详见 https://github.com/anishathalye/dotbot/wiki/Plugins -->

#### ONE_LINKS_CONF 数组

它可以用来管理多个 ONE_LINKS_CONF 文件，以便拆分和复用。

```sh
ONE_LINKS_CONF=("/a/one.links.yaml" "/b/one.lins.yaml")
```

#### ONE_LINKS_CONF 函数

`ONE_LINKS_CONF` 也可以是 Bash 函数，其返回值表示 [dotbot][] 配置的文件路径。

该函数接收两个参数：OS (`uname -s`) 和 Arch (`uname -m`)。必须用 `echo` 返回 ONE_LINKS_CONF 路径。

它可以用来管理不同系统下的不同 [dotbot][] 配置（比如 MacOS 和 Linux）。

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

## Dotbot 插件

用户可以通过 `one dotbot-plugin add` 添加 [dotbot 插件](https://github.com/anishathalye/dotbot/wiki/Plugins)。

举个例子，使用 https://github.com/DrDynamic/dotbot-git

执行 `one dotbot-plugin add DrDynamic/dotbot-git`

编辑 `ONE_LINKS_CONF` 文件：

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

执行 `one link`。


[one.links.example.yaml]: https://github.com/one-bash/one.share/blob/master/one.links.example.yaml
[dotbot]: https://github.com/anishathalye/dotbot/
