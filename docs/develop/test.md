# Test

## Add test cases

[../test/bin/one.bats](../test/bin/one.bats)

## Run test

`git submodule update --init --recursive` to install dependencies.

`make test` to test.

## Run test with act

Install [act](https://github.com/nektos/act) in local host.

`make act-mac` to test in mac host.
`make act-linux` to test in linux host.

## Run test with docker

```sh
./tools/test-in-docker  # defaults to BASHVER=4.4
BASHVER=5.0 ./tools/test-in-docker
```

## Run in docker

```sh
./tools/run-in-docker  # defaults to BASHVER=4.4
BASHVER=5.0 ./tools/run-in-docker
```
