FROM ubuntu:latest

ENV CONFIG_CMAKE=/tvm/cmake/config.cmake
ENV THREADS=8
ENV DEBIAN_FRONTEND=noninteractive

# Bring the image up to date
RUN apt update -y \
 && apt upgrade -y

# Install dependencies
RUN apt install -y \
        python3 \
        python3-dev \
        python3-setuptools \
        python3-pip \
        gcc \
        libtinfo-dev \
        zlib1g-dev \
        build-essential \
        cmake \
        libedit-dev \
        libxml2-dev \
        llvm \
        git

# Get TVM from GitHub and build
RUN git clone --recursive https://github.com/apache/tvm tvm \
 && cd tvm \
 && git submodule init \
 && git submodule update \
 && mkdir build \
 && cp $CONFIG_CMAKE build/config.cmake \
 && cd build \
 && cmake ../. \
 && make -j $THREADS

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Install TVM Python
RUN cd /tvm/python \
 && python3 setup.py install

# Build docs
RUN cd /tvm/docs \
 && TVM_TUTORIAL_EXEC_PATTERN=none make html
