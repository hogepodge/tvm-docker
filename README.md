# README.md for TVM-Docker

A Makefile-based system for building TVM Docker Containers for development and
deployment.

## Build your choice of base image

Step 1 is choosing your base image. The two choices are for CPU (Ubuntu-based)
or CUDA. Both are x86.

```
make host-ubuntu
```

or 

```
make host-cuda
```

Both of these will build a Docker image with the tag `tvm-host` that will be
used for the rest of the images. If you decide to change your host type, you
can revisit then step the build the rest of the containers from that. The
build host is simply a base image that has been updated and given some
useful environment variables, including a `HOST_IMAGE` variable that can be
queried later to customize installations and configurations.

## Build the dependencies image

`make dependencies`

The next image in the build chain installs all of the dependencies required
to install TVM successfully. This `tvm-dependencies` images is a nice start
if you want to do development from scratch without building TVM first.

## Build TVM into an image

`make build`

The next image in the build chain installs TVM from the main source branch.
This is a good starting point for working for working with TVM, but will
may require internal rebuilds if you're using it as a development environment.

## Build a smaller image with TVM Python

`make user`

If you're interested in just using TVM as a Python library is userspace, the
`tvm-user` container will take the build from the build container and use
the wheels to install it into the new container.

## Development Environment 

`make devel`

If you're interested in working in a full development environment, this
container sets up some things to help out with that. It add some additions
to the `.bashrc` that will use some environment variables on starting a shell
to point to your GitHub user. With this container built, there are a number of
additional `make` commands to start shells, build docs, and carry out other tasks

### Launching the developer image

`make run-devel` or `make gpu-devel`

Launches a development environment as daemon (calling `sleep infinity`), passing through
keys, GitHub information, Vim configuration, opening up a port for docs development. Use
the GPU version if you want to enable access to GPUs.

### Stopping the developer image

`make stop-devel`

Stops a running development environment.

### Starting a stopped developer image

`make start-devel`

Starts an existing and stopped development environment.

### Remove an existing developer environment

`make rm-devel`

Stops and removes a running development environment.

### Shell into a running developer environment

`make shell-devel`

Shells into a running development environment with Bash.

### Build docs in a running developer environment

`make docs`

Builds docs in a running development environment.

### Serve docs in a running developer environment

`make sphinx-serve`

Serves built documents from a running development environment over port 8081.

### Rebuild TVM

`make tvm`

Rebuilds TVM in a running development environment.

## Build an RPC Environment 

`make rpc`

Builds a minimal image that hosts the TVM runtime, suitable for inference and model tuning.
