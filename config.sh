#!/bin/bash
# For every subdirectory, enter that directory
# and run a standard set of installation commands
# pass a list of subdirectories to process
set -xe

readarray -td: pipeline <<< $1; declare -p pipeline
 
cd config

echo $pipeline

for package in ${pipeline[@]} ; do
    if test -d $package; then
        echo "Configuring $package"
        cd $package

        # install system dependencies
        if test -f apt.txt ; then
            # check for comments within the file then pass the package names apt install
            grep -vE '^#' apt.txt | xargs apt install -y
        else
            echo "No apt.txt file for $package, skipping package installation."
        fi

        # installs python dependencies
        if test -f pip.txt ; then
            pip3 install -r pip.txt
        else
            echo "No pip.txt file for $package, skipping pip package installation."
        fi

        # collect custom cmake configuration
        if test -f cmake.txt ; then
            cat cmake.txt >> /home/tvm/cmake.txt
        else
            echo "No cmake.txt file for $package, skipping custom cmake configuration."
        fi

        # run the custom script
        if test -f custom.sh ; then
            ./custom.sh
        else
            echo "No custom.sh script for $package, skipping custom script."
        fi

        cd ..
    else
        echo "Missing configuration directory $package."
    fi
done
