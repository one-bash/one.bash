#!/usr/bin/env bats

setup_fixture

@test "one sub list" {
	run one sub list

	assert_success
	assert [ "${#lines[@]}" -gt 1 ]
}
