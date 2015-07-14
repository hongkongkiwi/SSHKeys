#!/bin/bash
# Get script Directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Ensure we are in the script directory
cd "$DIR"
# Get changes from remote and reset local changes
/usr/bin/git fetch --quiet --all && git reset --quiet --hard origin/master

# Exit based on last command
exit $?

