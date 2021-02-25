# README.md for TVM-Docker

This set of Dockerfile and Makefile allows for quickly standing up and working
in a development environment for TVM. To get started, you can run `make build`
to download dependencies, download TVM, abd build TVM with a standard
configuration.

Once the container is built, you can then launch it as a development environment
by executing `make run`. This will launch the container and put it into an
infinite loop. It will also mount your `~/.ssh` directory read-only for key
access, and will set your Gitb variables based on your system settings.
Optionally you can export your GitHub username as `GITHUB_USERNAME` to set
a remote branch in the TVM repository to push work to.

After the container is running, you can shell in to it by calling `make shell`.
You can also serve documents for preview with `make sphinx-serve`. Finally,
when you are done working in the environment, you can call `make stop`. Note
that `make stop` is a destructive act, any work you have running in the
environment will be lost as the container is stopped and removed.
