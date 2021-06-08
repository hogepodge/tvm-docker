# README.md for TVM-Docker

This set of Dockerfile and Makefile allows for quickly standing up and working
in a development environment for TVM. To get started, you can run
`make tvm-devel` to download dependencies, download TVM, and build TVM with a
standard configuration.

Once the container is built, you can then launch it as a development environment
by executing `make run`. This will launch the container and put it into an
infinite loop. It will also mount your `~/.ssh` directory read-only for key
access, and will set your git variables based on your system settings.
Optionally you can export your GitHub username as `GITHUB_USERNAME` to set
a remote branch in the TVM repository to push work to.

After the container is running, you can shell in to it by calling `make shell`.
You can also serve documents for preview with `make sphinx-serve`.

If you want to stop the container, you can call `make stop`. You can restart it
with `make start`. If you are done working with a container, you can run
`make clean` which will stop and remove the container. Note that this is a
destructive act, any work you have running in the environment will be lost as
the container is stopped and removed.

## Configuration
This Dockerfile uses a pipeline approach for building an image. This means
you can configure it to use new configurations. For configuration of
TVM, add a new directory that corresponds to the feature you want to enable.
If you need to insall system or python dependencies, the `apt.txt` and
`pip.txt` files can list the dependencies you want to install. You can include
cmake settings to be appended to the build configuration in the `cmake.txt`
file, and `custom.sh` is the entrypoint for custom scripts.

Similarly, if you need to add to the build pipeline, you can add a directory
in the `build` directory with a custom `build.sh` script.

You will need to pass the environment variables `CONFIG_PIPELINE` and
`BUILD_PIPELINE` with the updated pipeline, using the names of the directories
separated by colons. Order matters, as cmake variables that are set in one
stage of the pipeline may be overwritten by variables set later in the pipeline.

## Big Caveat!

The environment is intended for development only. Things like password-less
`sudo` and mounting of your private ssh keys make it entirely unsuitable for
production. If you try to run this on a publicly available system you are just
tsking for trouble so don't do that. Local development only!
