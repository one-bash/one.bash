.PHONY: act-linux act-mac test

test:
	./tools/test

act-linux:
	./tools/act linux

act-mac:
	./tools/act mac
