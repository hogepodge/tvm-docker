SHELL := /bin/bash
host-ubuntu:
	docker build . \
		-t tvm-host-ubuntu \
		--progress=plain \
		-f docker/host/ubuntu/Dockerfile.host-ubuntu; \
	docker tag tvm-host-ubuntu tvm-host

host-cuda:
	docker build . \
		-t tvm-host-cuda \
		--progress=plain \
		-f docker/host/cuda/Dockerfile.host-cuda; \
	docker tag tvm-host-cuda tvm-host

dependencies:
	docker build . \
		-t tvm-dependencies \
		--progress=plain \
		-f docker/dependencies/Dockerfile.dependencies

build: dependencies
	docker build . \
		-t tvm-build \
		--progress=plain \
		-f docker/build/Dockerfile.build

user: build
	docker build . \
		-t tvm-user \
		--progress=plain \
		-f docker/user/Dockerfile.user

devel: build
	docker build . \
		-t tvm-devel \
		--progress=plain \
		-f docker/devel/Dockerfile.devel

rpc: build
	docker build \
		-t tvm-rpc \
		--progress=plain \
		-f docker/rpc/Dockerfile.rpc \
		.

run-devel:
	GIT_USERNAME="$(shell git config user.name)" \
	GIT_EMAIL="$(shell git config user.email)" \
	docker run \
		-v $(HOME)/.ssh:/home/tvm/.ssh:ro \
		-v $(HOME)/.vim:/home/tvm/.vim:ro \
		-v $(CURDIR)/workspace:/home/tvm/workspace \
		-e GIT_USERNAME \
        -e GIT_EMAIL \
		-e GITHUB_USERNAME \
		-p 8081:8081 \
		-d \
		--name tvm_devel \
		tvm-devel \
		sleep infinity
#		-v $(CURDIR)/setup:/home/tvm/.setup:ro \
#		--gpus all \

stop-devel:
	docker stop tvm_devel

start-devel:
	docker start tvm_devel

shell-devel:
	docker exec \
		-it \
		-e GITHUB_USERNAME \
		tvm_devel \
		bash

rm-devel:
	docker stop tvm_devel; \
	docker rm tvm_devel;

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

clean:
	docker stop tvm_devel
	docker rm tvm_devel

imageclean:
	docker image rm tvm-devel

rm:
	docker rm $$(docker ps -a -q)

