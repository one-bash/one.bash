# ONE Dependencies

`one dep install` will download below four dependencies into [deps/](../../deps).

- [dotbot][]: To create symbol links and manage them with config.
- [composure][]: Provides functions for modules
- [one.share][]: It can be disabled by `ONE_SHARE_ENABLE=false` in `ONE_CONF`.
- [bash-it](https://github.com/Bash-it/bash-it): It can be disabled by `ONE_BASH_IT_ENABLE=false` in `ONE_CONF`.

You can use `one dep` to manage these dependencies.

- `one dep install` to install all dependencies.
- `one dep update` to update all dependencies.
- `one dep update <dep>` to update a dependency.


<!-- links -->

[composure]: https://github.com/adoyle-h/composure.git
[dotbot]: https://github.com/anishathalye/dotbot/
[bash-it]: https://github.com/Bash-it/bash-it
[one.share]: https://github.com/one-bash/one.share
