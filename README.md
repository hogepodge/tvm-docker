# README.md for TVM-Docker

A Makefile-based system for building TVM Docker Containers for development and
deployment.

## Step 1: Choose your base image - `make host-ubuntu` or `make host-cuda`

Step 1 is choosing your base image. The two choices are for CPU (Ubuntu-based)
or CUDA. Both are x86.

```
make host-ubuntu
```

or 

```
make host-cuda
```

Both of this will build a Docker image with the tag `tvm-host` that will be
used for the rest of the images. If you decide to change your host type, you
can revisit then step the build the rest of the containers from that. The
build host is simply a base image that has been updated and given some
useful environment variables, including a `HOST_IMAGE` variable that can be
queried later to customize installations and configurations.

## Step 2: Build the rest of the images you want

### Dependencies `make tvm-dependencies`

The next image in the build chain installs all of the dependencies required
to install TVM successfully. This `tvm-dependencies` images is a nice start
if you want to do development from scratch without building first.

### Build `make tvm-build` for `tvm-build` image

The next image in the build chain installs TVM from the main source branch.
This is good as a starting point for working for working with TVM, but will
may require internal rebuilds if you're using it as a development environment.

###  User Installation `make tvm-user` for `tvm-user` image

If you're interested in just using TVM as a Python library is userspace, the
`tvm-user` container will take the build from the build container and use
the wheels to install it into the new container.

### Development Environment `make tvm-devel` for `tvm-devel` image

If you're interested in working in a full development environment, this
container sets up some things to help out with that. It add some additions
to the `.bashrc` that will use some environment variables on starting a shell
to point to your GitHub user. With this container built, there are a number of
additional `make` commands to start shells, build docs, and carry out other tasks

#### `make run-devel` or `make gpu-devel`

Launches a development environment as daemon (calling `sleep infinity`), passing through
keys, GitHub information, Vim configuration, opening up a port for docs development. Use
the GPU version if you want to enable access to GPUs.

#### `make stop-devel`

Stops a running development environment.

#### `make shell-devel`

Shells into a running development environment.

#### `make start-devel`

Starts an existing and stopped development environment.

#### `make rm-devel`

Stops and removes a running development environment.

#### `make docs`

Builds docs in a running development environment.

#### `make sphinx-serve`

Serves built documents from a running development environment over port 8081.

#### `make tvm`

Rebuilds TVM in a running development environment.

### RPC Environment `make tpc` for `tvm-rpc` image

Builds a minimal image that hosts the TVM runtime, suitable for inference and model tuning.
