FROM tvm-deps:latest

# Create the tvm user
RUN groupadd -r tvm -g 3604 \
 && useradd -u 3604 -r -g tvm -m -c "TVM user" -s /bin/bash tvm \
 && usermod -aG sudo tvm \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER tvm

# Download TVM
RUN cd \
 && git clone --recursive https://github.com/apache/tvm tvm \
 && cd tvm \
 && git submodule init \
 && git submodule update

# Set up the build directory
RUN cd /home/tvm/tvm \
 && mkdir build

# Copy the config.cmake file over
COPY config.cmake /home/tvm/build/config.cmake

ENV THREADS=8

# Build TVM
RUN cd /home/tvm/tvm/build \
 && cmake ../. \
 && make -j $THREADS

# Install TVM Python
RUN cd ~/tvm/python \
 && python3 setup.py install --user

# Build docs
RUN cd ~/tvm/docs\
 && TVM_TUTORIAL_EXEC_PATTERN=none make html

# Set up a local user development environment

# Adds the local python installation environment to the path
RUN cd /home/tvm \
 && echo "export PATH=$PATH:/home/tvm/.local/bin" >> .bashrc

# Add scripting to .bashrc that allows setting up of local
# github environment to load environment variables
# This may not be appropiate for a build container
# TODO consider other solutions
COPY setup /home/tvm/.setup
RUN echo "source .setup" >> /home/tvm/.bashrc

# Set up the working space
WORKDIR /home/tvm
