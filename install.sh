#!/bin/bash

##
# This script is designed to be run remotely if you don't have it setup 
yet on this computer, that is about it
##

CLONE_BASE_PATH="$HOME/.ssh"
CLONE_NAME="SSHKeys"
CLONE_PATH="$CLONE_BASE_PATH/$CLONE_NAME"
CRONTAB_SCRIPT="$CLONE_PATH/crontab.sh"
REPO_AUTHORIZED_KEYS_FILE="$CLONE_PATH/authorized_keys"
AUTHORIZED_KEYS_FILE="$HOME/.ssh/authorized_keys"
REPO_URL="https://github.com/hongkongkiwi/SSHKeys.git"
GIT_CMD="/usr/bin/git"

echo "Attempting to install SSH authorized_keys cloner"

# It's important that we have Git on the local machine
if [[ ! -f "$GIT_CMD" ]]; then
    echo "Git is not installed! Please install with apt-get install git 
first"
    exit 255
else
    echo "-> Hooray! Git is installed on local system"
fi

# Check if .ssh directory exists, if not create it
if [[ ! -d "$CLONE_BASE_PATH" ]]; then
    mkdir -p "$CLONE_BASE_PATH"
else
    echo "-> .ssh directory exists for current user $USER"
fi

# Check if SSHKeys directory already exists
if [[ -d "$CLONE_PATH" ]]; then
    if [ -d "$CLONE_PATH/.git" ] || "$GIT_CMD -C $CLONE_PATH" rev-parse 
--git-dir > /dev/null 2>&1; then
        echo "-> Directory already exists and is a Git repo, will update 
from master repo instead"
        #bash $CRONTAB_SCRIPT
    else
            echo "X> $CLONE_PATH directory exists and is NOT a git repo"
        echo "ERROR: Please fix this manually by removing the existing 
SSHKeys directory"
        echo "       You can run the following command to do it but make 
sure you know what your doing!"
        echo "rm -Rf $CLONE_PATH"
        exit 253
    fi
else
    echo "-> Cloning repository into $CLONE_PATH"
    #"$GIT_CMD" clone "$REPO_URL"
fi

if [[ -f "$AUTHORIZED_KEYS_FILE" ]]; then
    if [[ -h "$AUTHORIZED_KEYS_FILE" ]]; then
        existing_symlink=`readlink -f "$AUTHORIZED_KEYS_FILE"`
        if [[ "$existing_symlink" == "$REPO_AUTHORIZED_KEYS_FILE" ]]; 
then
            echo "-> Authorized Keys file already exists and is a 
symbolic link"      
        else
            echo "X> Authorized Keys file already exists and is a 
symbolic link pointing to $existing_symlink"
            echo "ERROR: I don't know how to deal with this, please 
manaually create the link using this command and re-run the install"
            echo "ln -s\"$REPO_AUTHORIZED_KEYS_FILE\" 
\"$AUTHORIZED_KEYS_FILE\""
            exit 254
        fi
    else
        BAKNAME=`basename "$AUTHORIZED_KEYS_FILE""
        echo "-> Authorized Keys file already exists, baking up to 
$BAKNAME.bak"
        mv "$AUTHORIZED_KEYS_FILE" "$AUTHORIZED_KEYS_FILE.bak"
    fi
else
    echo "-> Setting up symbolic link for Authorized Keys file"
    ln -s "$REPO_AUTHORIZED_KEYS_FILE" "$AUTHORIZED_KEYS_FILE"
fi

echo "Setup successfully installed SSHKeys"
echo
echo "FOR AUTOMATED KEY UPDATING PLEASE ADD THE FOLLOWING TO CRONTAB"
echo "@daily $CRONTAB_SCRIPT"

exit 0

