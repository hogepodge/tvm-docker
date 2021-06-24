#!/bin/bash
# For every subdirectory, enter that directory
# and run the custom build commands

# pass a list of subdirectories to process
set -xe

readarray -td: pipeline <<< $1; declare -p pipeline

cd build

for package in ${pipeline[@]} ; do
    if test -d $package; then
        echo "Building $package"
        cd $package

        if test -f build.sh ; then
            ./build.sh
        else
            echo "No build.sh script for $package, skipping custom script."
        fi

        cd ..
    else
        echo "Missing configuration directory $package."
    fi
done
