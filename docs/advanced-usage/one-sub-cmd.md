# ONE_SUB Command

## Use ONE_SUB Commands

All executable files in `sub/` of each [repo](./repo.md) could be invoked
by `one subs <cmd>` or `a <cmd>` (`$ONE_SUB <cmd>`, `ONE_SUB` defaults to `a`, read the usage in [`ONE_CONF`](../one.config.default.bash)).

The `sub/` path is not included in `$PATH`. So you cannot invoke ONE_SUB commands directly.

## Write a ONE_SUB Command

Create a file in `sub/` of a repo. And make it executable via `chmod +x <file>`.

Here is a command template.

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

### ONE_SUB Command Document

Add `# one.bash:usage:--help` or `# one.bash:usage` in file,
so that user can use `one help-sub <cmd>` or `$ONE_SUB help <cmd>` to show command usage.
one.bash will pass `--help` to ONE_SUB command.

`# one.bash:usage:--help` means that `one help-sub` will pass `--help`.
If your command received another option for printing usage, for example `-H` option, just set `# one.bash:usage:-H`.

Invoke `$ONE_SUB help -a` to list all usages of ONE_SUB commands.

Invoke `$ONE_SUB help <cmd>` for the usage of this ONE_SUB command.

### ONE_SUB Command Completion

Add `# one.bash:completion` in file, so that user can type `<Tab>` for completion `one subs` commands.
one.bash will pass `--complete` to file.

If not set `# one.bash:completion`, the `one subs` completion will not work.

```sh
# one.bash:completion
if [[ "${1:-}" = "--complete" ]]; then
  # your completion code
  exit 0
fi
```

You should print each completion option for one line. Do not `echo "option-1 option-2"` with spaces.

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

Below codes are filepath completion for current word under cursor.

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
