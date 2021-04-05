FROM tvm-deps:latest

USER tvm

ENV CONFIG_CMAKE=/home/tvm/tvm/cmake/config.cmake
ENV THREADS=8

COPY config_cmake.sh /home/tvm/config_cmake.sh

RUN cd ~/tvm \
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
