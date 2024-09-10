#!/usr/bin/env bats

setup_fixture

@test "one sub" {
	run one sub

	assert_success
	assert [ "${#lines[@]}" -gt 1 ]
}
