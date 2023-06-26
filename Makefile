include ./makefile-utils/*.mk
.DEFAULT_GOAL := help

deps: deps/one_l.bash deps/lobash.bash

deps/one_l.bash:
	lobash-gen -c ./deps/one_l.conf ./deps/one_l.bash

deps/lobash.bash:
	lobash-gen -y -m 4.4 -p l. ./deps/lobash.bash

.PHONY: act-linux act-mac test

test:
	./tools/test

act-linux:
	./tools/act linux

act-mac:
	./tools/act mac

# @target bump-major  bump major version (x)
# @target bump-minor  bump minor version (y)
# @target bump-patch  bump patch version (z)
BUMP_TARGETS := $(addprefix bump-,major minor patch)
.PHONY: $(BUMP_TARGETS)
$(BUMP_TARGETS):
	@$(MAKE) $(subst bump-,semver-,$@) > VERSION

.PHONY: changelog
# @desc Generate and update the CHANGELOG file
changelog:
	$(MAKE) CHANGELOG NEXT_VERSION=$(shell cat VERSION)
