FROM ubuntu:latest

USER root

ENV CONFIG_CMAKE=/home/tvm/tvm/cmake/config.cmake
ENV THREADS=8
ENV DEBIAN_FRONTEND=noninteractive

# Bring the image up to date
RUN apt-get dist-upgrade -y \
 && apt update -y \
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
        git \
        sudo \
        vim

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Create the tvm user
RUN groupadd -r tvm -g 3604 \
 && useradd -u 3604 -r -g tvm -m -c "TVM user" -s /bin/bash tvm \
 && usermod -aG sudo tvm \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER tvm

COPY config_cmake.sh /home/tvm/config_cmake.sh

# Get TVM from GitHub and build
RUN cd \
 && git clone --recursive https://github.com/apache/tvm tvm \
 && cd tvm \
 && git submodule init \
 && git submodule update \
 && mkdir build \
 && cp $CONFIG_CMAKE build/config.cmake \
 && cd build \
 && ~/config_cmake.sh \
 && cmake ../. \
 && make -j $THREADS


# Install TVM Python
RUN cd ~/tvm/python \
 && python3 setup.py install --user

# Build docs
RUN cd ~/tvm/docs\
 && TVM_TUTORIAL_EXEC_PATTERN=none make html

# Set up the working space
WORKDIR /home/tvm
RUN cd \
 && echo "export PATH=$PATH:/home/tvm/.local/bin" >> .bashrc
RUN echo "source .setup" >> .bashrc
