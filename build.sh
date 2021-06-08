#!/bin/bash
# For every subdirectory, enter that directory
# and run the custom build commands

# pass a list of subdirectories to process
set -x

IFS=":" read -a pipeline <<< $1

cd build

for package in $pipeline ; do
    if test -d $package; then
        # run the custom script
        if test -f build.sh ; then
            ./build.sh
        else
            echo "No build.sh script for $package, skipping custom script."
        fi
    else
        echo "Missing configuration directory $package."
    fi
done
