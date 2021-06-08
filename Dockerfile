FROM ubuntu:latest

# The pipeline is a colon separated ordered list
ARG CONFIG_PIPELINE=base:devel
ARG BUILD_PIPELINE=build:python:docs

USER root

# Make apt non-interactive to keep installation from being blocked
ENV DEBIAN_FRONTEND=noninteractive

# Bring the image up to date
RUN apt-get dist-upgrade -y \
 && apt update -y \
 && apt upgrade -y \
 && apt install -y git

# The pipeline scripts
ADD config.sh config.sh
ADD build.sh build.sh

# The pipeline directories
ADD config config
ADD build build

# Create the tvm user
RUN groupadd -r tvm -g 3604 \
 && useradd -u 3604 -r -g tvm -m -c "TVM user" -s /bin/bash tvm \
 && usermod -aG sudo tvm \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN ./config.sh $CONFIG_PIPELINE

USER tvm

# Download TVM
RUN cd \
 && git clone --recursive https://github.com/apache/tvm tvm \
 && cd tvm \
 && git submodule init \
 && git submodule update

# Set up the build directory
RUN cd /home/tvm/tvm \
 && mkdir build \
 && cat /home/tvm/tvm/cmake/config.cmake /home/tvm/cmake.txt >> build/config.cmake

ENV THREADS=8

# Run the custom build pipeline
RUN ./build.sh $BUILD_PIPELINE

# Set up the working space
WORKDIR /home/tvm

