#!/bin/bash

# This function is for executing shell commands and taking action based on return code
function cmd() {
    eval $1
    if [ $? -eq 0 ]
    then
        echo -e "$2"
    else
        echo -e "$3"
        exit 1
    fi
}

# This function is for getting config parameters from config file
function getConfigs() {
    if [ $# -eq 0 ]
    then
        echo ""
    else
        cfgvalue=`grep -m 1 ^$@ $CONFIG |  awk 'BEGIN{FS="="}{print $2}'`
        echo $cfgvalue
    fi
}

# This function is for validating file existence
function isFileExists() {
    if [ ! -f "$1" ]
    then
        echo "File $1 not found."
        exit 1
    fi
}

# This function if for creating directory
function createDir() {
    mkdir "$1"
    if [ $? -ne 0 ]
    then
        echo "Failed to create directory $1"
        exit 1
    fi
}

