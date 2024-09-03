#!/usr/bin/env bats

setup_fixture

PATH="$BATS_TEST_DIRNAME/../../bin:$PATH"

@test "one help log" {
  run one help -a

  assert_success
  assert [ "${#lines[@]}" -gt 30 ]
}


@test "one help -a" {
  run one help -a

  assert_success
  assert [ "${#lines[@]}" -gt 30 ]
}

