#!/bin/bash

##
# This script updates the authorized keys file regularly from our git repo
##

# Read config file location from first input param
CONFIG_FILE=${1:-"$HOME/.ssh/sshkeys.conf"}

# Takes a config file and sources it with a few simple checks
read_config () {
    if [ ! -f "$1" ]; then
        echo "Config file $CONFIG_FILE not found!"
        exit 1
    fi

    # now source it, either the original or the filtered variant
    source "$1"
}

read_config "$CONFIG_FILE"

GIT_BIN=${GIT_BIN:-"/usr/local/bin/git"}

if [[ "$REPO_URL" == "" ]]; then
    echo "REPO_URL variable in config file is blank!"
    exit 2
fi

# Get changes from remote and reset local changes
"$GIT_BIN" -C "$REPO_URL" fetch --quiet --all && "$GIT_BIN" -C "$REPO_URL" reset --quiet --hard origin/master

# Exit based on last command
exit $?

