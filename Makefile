include ./makefile-utils/*.mk
.DEFAULT_GOAL := help

deps: deps/one_l.bash deps/lobash.bash

deps/one_l.bash:
	lobash-gen -c ./deps/one_l.conf ./deps/one_l.bash

deps/lobash.bash:
	lobash-gen -y -m 4.4 -p l. ./deps/lobash.bash

.PHONY: act-linux act-mac test test-local

test:
	./tools/test

test-local:
	BATS_TAGS=!ci ./tools/test

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
	@$(MAKE) -s $(subst bump-,semver-,$@) > VERSION

.PHONY: changelog
# @desc Generate and update the CHANGELOG file
changelog:
	$(MAKE) -s CHANGELOG NEXT_VERSION=$(shell cat VERSION)

.PHONY: new-tag
new-tag:
	@git tag v$(shell cat VERSION)

# @target release-major  release major version (x)
# @target release-minor  release minor version (y)
# @target release-patch  release patch version (z)
RELEASE_TARGETS := $(addprefix release-,major minor patch)
.PHONY: $(RELEASE_TARGETS)
$(RELEASE_TARGETS):
	@$(MAKE) -s $(subst release-,bump-,$@)
	@$(MAKE) -s changelog
	@git add .
	@git commit -m "bump: $(subst release-,,$@) version"
	@git rebase develop main
	@$(MAKE) -s new-tag

.PHONY: format
format:
	shfmt -s -w -ln=auto -i 0 -ci --apply-ignore ./bash/ ./bin/ ./one-cmds/ ./one.config.default.bash ./test/ ./tools/
