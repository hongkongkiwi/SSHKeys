#!/bin/bash

##
# This script updates the authorized keys file regularly from our git repo
##

# Get script Directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
GIT_BIN="/usr/bin/git"
REPO_PATH="$HOME/.ssh/SSHKeys"

# Get changes from remote and reset local changes
"$GIT_BIN" -C "$REPO_PATH" fetch --quiet --all && "$GIT_BIN" -C "$REPO_PATH" reset --quiet --hard origin/master

# Exit based on last command
exit $?

