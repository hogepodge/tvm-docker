SHELL := /bin/bash

tvm-devel:
	docker build \
		-t tvm-devel \
		.

run:
	GIT_USERNAME="$(shell git config user.name)" \
	GIT_EMAIL="$(shell git config user.email)" \
	docker run \
		-it \
		-v $(HOME)/.ssh:/home/tvm/.ssh:ro \
		-v $(CURDIR)/setup:/home/tvm/setup:ro \
		-e GIT_USERNAME \
        -e GIT_EMAIL \
		-e GITHUB_USERNAME \
		tvm-devel \
		bash

rm:
	docker rm $$(docker ps -a -q)
