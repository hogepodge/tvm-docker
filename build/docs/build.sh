#!/bin/bash

set -x

# Build docs
cd /home/tvm/tvm/docs
TVM_TUTORIAL_EXEC_PATTERN=none make html
