.PHONY: release build run run_with_redis

# Change test to the latest 'correct' binary
binary_path = ./test_helpers/stages/basic_exec_correct.sh
current_version = $(shell git describe --tags --abbrev=0)

release:
	rm -rf dist
	goreleaser

build:
	go build -o dist/main.out

test: build
	dist/main.out --stage 100 --binary-path=$(binary_path)

test_debug: build
	dist/main.out --stage 100 --binary-path=$(binary_path) --debug=true

report: build
	dist/main.out --stage 100 --binary-path=$(binary_path) --report --api-key=abcd

bump_version:
	bumpversion --verbose --tag patch

upload_to_travis:
	aws s3 cp --acl public-read \
		s3://paul-redis-challenge/binaries/$(current_version)/$(current_version)_linux_amd64.tar.gz \
		s3://paul-redis-challenge/linux.tar.gz
	aws s3 cp --acl public-read \
		s3://paul-redis-challenge/binaries/$(current_version)/$(current_version)_darwin_amd64.tar.gz \
		s3://paul-redis-challenge/darwin.tar.gz

bump_release_upload: bump_version release upload_to_travis
