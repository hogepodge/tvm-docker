#!/bin/bash

set -x

# Build TVM
cd /home/tvm/tvm/build
cmake ../.
make -j $THREADS
