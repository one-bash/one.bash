#!/usr/bin/env bats

setup_fixture

PATH="$BATS_TEST_DIRNAME/../../bin:$PATH"

@test "one" {
  run one

  assert_success
  assert_output -p 'Usage:'
  assert_output -p 'Desc:'
  assert_output -p 'Arguments:'
}

@test "one commands" {
  run one commands

  assert_success
  assert_line -n 0 alias
  assert_line -n 1 backup-enabled
  assert_line -n 2 bin
  assert_line -n 3 commands
  assert_line -n 4 completion
  assert_line -n 5 config
  assert_line -n 6 debug
  assert_line -n 7 dep
  assert_line -n 8 help
  assert_line -n 9 help-sub
  assert_line -n 10 link
  assert_line -n 11 plugin
  assert_line -n 12 repo
  assert_line -n 13 sub
  assert_line -n 14 unlink
}

@test "one sub list" {
  run one sub list

  assert_success
  assert [ "${#lines[@]}" -gt 10 ]
}

@test "one help -a" {
  run one help -a

  assert_success
  assert [ "${#lines[@]}" -gt 30 ]
}
