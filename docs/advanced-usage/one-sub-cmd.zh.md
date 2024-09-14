# ONE_SUB 命令

## 使用 ONE_SUB 命令

放在每个 [REPO](./repo.zh.md) 的 `sub/` 目录下的可执行文件，都可以使用 `one sub run <cmd>` 或 `a <cmd>` 调用。（`$ONE_SUB <cmd>`, `ONE_SUB` 默认值为 `a`，详见 [`ONE_CONF`][one.config.default]）

`sub/` 路径没有包含在环境变量 `$PATH`，所有你无法直接调用 ONE_SUB 命令。


## 写一个 ONE_SUB 命令

在 repo 的 `sub/` 中创建一个文件。并通过 `chmod +x <file>` 使其可执行。

下面是一个模板。

```sh
#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace
(shopt -p inherit_errexit &>/dev/null) && shopt -s inherit_errexit

# one.bash:completion
if [ "${1:-}" = --complete ]; then
  printf '-h\n--help\n'
  exit
fi

# one.bash:usage:--help
if (( $# == 0 )) || [[ $1 == -h ]] || [[ $1 == --help ]]; then
  cat <<EOF
Usage: $ONE_SUB $(basename "$0") [OPTIONS] <ARGUMENTS>
Desc:
Arguments:
Options:
EOF
  exit 0
fi

# Put your codes here
```

### ONE_SUB 命令文档

在文件中添加 `# one.bash:usage:--help` 或 `# one.bash:usage`。
以便用户可以使用 `one help-sub <cmd>` 或 `$ONE_SUB help <cmd>` 来显示命令的用法。
one.bash 会将 `--help` 传递给 ONE_SUB 命令。

`# one.bash:usage:--help` 表示 `one help-sub` 将传递 `--help`。
如果您的命令有其他打印用法的选项，例如 `-H` 选项，只需设置 `# one.bash:usage:-H`。

调用 `$ONE_SUB help -a` 列出 ONE_SUB 命令的所有用法。

调用 `$ONE_SUB help <cmd>` 查看该 ONE_SUB 命令的用法。

### ONE_SUB 命令补全

在文件中添加 `# one.bash:completion`，这样用户就可以输入 `<Tab>` 来补全 ONE_SUB 命令。
当用户按下 `<Tab>`，one.bash 会将 `--complete` 传递给 ONE_SUB 文件。

如果不设置 `# one.bash:completion`，shell 将无法补全 ONE_SUB 命令。

```sh
# one.bash:completion
if [[ "${1:-}" = "--complete" ]]; then
  # your completion code
  exit 0
fi
```

应将每个补全项打印一行。不要这样写：`echo "option-1 option-2"` 。

```sh
# one.bash:completion
if [[ "${1:-}" = "--complete" ]]; then
  if [[ $COMP_CWORD -lt 3 ]]; then
    words=(open close --help)
    printf '%s\n' "${words[@]}"
  fi
  exit 0
fi
```

以下代码用于补全光标下当前字词的文件路径。

```sh
# one.bash:completion
if [[ "${1:-}" == --complete ]]; then
  if (( COMP_CWORD < 3 )); then
    result=$(compgen -f -- "$2")
    if [[ -d $result ]]; then
      compgen -f -- "$result/"
    else
      echo "${result[@]}"
    fi
  fi
  exit 0
fi
```
