# Test

## Add test cases

[../test/bin/one.bats](../test/bin/one.bats)

## Run test in Mac host

Install [act](https://github.com/nektos/act) in local host.

`make act-mac` to test.

## Run test in docker

Install [act](https://github.com/nektos/act) in local host.

`make act-linux` to test.

or

```sh
./tools/test-in-docker  # defaults to BASHVER=4.4
BASHVER=5.0 ./tools/test-in-docker
```

## Run test in host

Install [bats](https://github.com/bats-core/bats-core).

`./tools/test` to test.

## Run in docker

```sh
./tools/run-in-docker  # defaults to BASHVER=4.4
BASHVER=5.0 ./tools/run-in-docker
```
