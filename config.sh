#!/bin/bash
# For every subdirectory, enter that directory
# and run a standard set of installation commands
# pass a list of subdirectories to process

IFS=":" read -a pipeline <<< $1

cd config

for package in $pipeline ; do
    cd $package

    # installs system dependencies
    grep -vE '^#' apt.txt | xargs apt install -y

    # installs python dependencies
    pip3 install -r pip.txt

    # collect custom cmake configuration
    cat cmake.txt >> /home/tvm/cmake.txt
done
