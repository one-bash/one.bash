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

# bats test_tags=ci
@test "one sub list" {
	run one sub list

	assert_success
	assert [ "${#lines[@]}" -eq 0 ]
}

@test "one help -a" {
	run one help -a

	assert_success
	assert [ "${#lines[@]}" -gt 30 ]
}
