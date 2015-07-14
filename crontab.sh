#!/bin/bash

##
# This script updates the authorized keys file regularly from our git repo
##

# Read config file location from first input param
CONFIG_FILE=${1:-"$HOME/.ssh/sshkeys.conf"}

# Takes a config file and sources it with a few simple checks
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file $CONFIG_FILE not found!"
    exit 1
fi

# now source it, either the original or the filtered variant
source "$CONFIG_FILE"

[ "$GIT_BIN" == "" ] && echo "GIT_BIN variable in config file is blank!" && exit 2
[ "$REPO_URL" == "" ] && echo "REPO_URL variable in config file is blank!" && exit 2
[ "$REPO_PATH" == "" -o ! -d "$REPO_PATH" ] && echo "REPO_PATH variable in config file is invalid or blank!" && exit 2

cd "$REPO_PATH"

# Get changes from remote and reset local changes
"$GIT_BIN" fetch --quiet --all && "$GIT_BIN" reset --quiet --hard origin/master

# Exit based on last command
exit $?

