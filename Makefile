SHELL := /bin/bash

tvm-devel:
	docker build \
		-t tvm-devel \
		--progress=plain \
		.

devel-nocache:
	docker build \
		-t tvm-devel \
		--progress=plain \
		--no-cache \
		.

minimal:
	docker build \
		-t tvm-minimal \
		--progress=plain \
		-f Dockerfile.minimal \
		.

rpc:
	docker build \
		-t tvm-rpc \
		--progress=plain \
		-f Dockerfile.rpc \
		--no-cache \
		.

run:
	GIT_USERNAME="$(shell git config user.name)" \
	GIT_EMAIL="$(shell git config user.email)" \
	docker run \
		-v $(HOME)/.ssh:/home/tvm/.ssh:ro \
		-v $(HOME)/.vim:/home/tvm/.vim:ro \
		-e GIT_USERNAME \
        -e GIT_EMAIL \
		-e GITHUB_USERNAME \
		-p 8081:8081 \
		-d \
		--name tvm_devel \
		tvm-devel \
		sleep infinity

#		-v $(CURDIR)/setup:/home/tvm/.setup:ro \

shell:
	docker exec \
		-it \
		-e GITHUB_USERNAME \
		tvm_devel \
		bash

sphinx-serve:
	docker exec \
		-d \
		tvm_devel \
		bash -c "cd tvm/docs/_staging ; sphinx-serve"

docs:
	docker exec \
 		tvm_devel \
 		bash -c "cd tvm/docs; TVM_TUTORIAL_EXEC_PATTERN=/vta/tutorials make html"

tvm:
	docker exec \
		tvm_devel \
		bash -c "cd tvm/build; make -j 8"

stop:
	docker stop tvm_devel

start:
	docker start tvm_devel

clean:
	docker stop tvm_devel
	docker rm tvm_devel

imageclean:
	docker image rm tvm-devel

rm:
	docker rm $$(docker ps -a -q)

