.PHONY: act-linux act-mac test

test:
	./tools/test

act-linux:
	act local -j linux -W ./.github/workflows/local.yaml

act-mac:
	act local -j linux -W ./.github/workflows/local.yaml
