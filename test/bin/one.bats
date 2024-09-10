#!/usr/bin/env bats

setup_fixture

@test "one" {
	run one

	assert_success
	assert_output -p 'Usage:'
	assert_output -p 'Desc:'
	assert_output -p 'Arguments:'
}

@test "one help -a" {
	run one help -a

	assert_success
	assert [ "${#lines[@]}" -gt 20 ]
}
