SHELL := /bin/bash

tvm-devel:
	docker build \
		-t tvm-devel \
		.

run:
	GIT_USERNAME="$(shell git config user.name)" \
	GIT_EMAIL="$(shell git config user.email)" \
	docker run \
		-v $(HOME)/.ssh:/home/tvm/.ssh:ro \
		-v $(CURDIR)/setup:/home/tvm/.setup:ro \
		-v $(HOME)/.vim:/home/tvm/.vim:ro \
		-e GIT_USERNAME \
        -e GIT_EMAIL \
		-e GITHUB_USERNAME \
		-p 8081:8081 \
		-d \
		--name tvm_devel \
		tvm-devel \
		sleep infinity

shell:
	docker exec \
		-it \
		tvm_devel \
		bash

sphinx-serve:
	docker exec \
		-d \
		tvm_devel \
		bash -c "cd tvm/docs ; sphinx-serve"

stop:
	docker stop tvm_devel

start:
	docker start tvm_devel

clean:
	docker stop tvm_devel
	docker rm tvm_devel

rm:
	docker rm $$(docker ps -a -q)

