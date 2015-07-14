#!/bin/bash

##
# This script is designed to be run remotely if you don't have it setup yet on this computer, that is about it
##

# We dont need root and it may confuse some things
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run this script as root!"
    exit 2
fi

# Check which OS we are running
PLATFORM='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   PLATFORM='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   PLATFORM='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   PLATFORM='mac'
fi

CLONE_BASE_PATH="$HOME/.ssh"
CLONE_NAME="SSHKeys"
CLONE_PATH="$CLONE_BASE_PATH/$CLONE_NAME"
CRONTAB_SCRIPT="$CLONE_PATH/crontab.sh"
REPO_AUTHORIZED_KEYS_FILE="$CLONE_PATH/authorized_keys"
AUTHORIZED_KEYS_FILE="$HOME/.ssh/authorized_keys"
REPO_URL="https://github.com/hongkongkiwi/SSHKeys.git"
GIT_BIN="/usr/bin/git"
CRON_CMD="/bin/bash \"$CRONTAB_SCRIPT\" > /dev/null"
CRON_JOB="@hourly $CRON_CMD"

### SETUP SOME USEFUL FUNCTIONS ###
confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

### SCRIPT STARTS FROM HERE ###

echo "This will install SSHKeys for automated updating of public key logins"
if [[ $(confirm "Are you sure you want proceed? [y/N]: "; echo $?) -ne 0 ]]; then
    echo "- Aborted"
    exit 1
fi

# It's important that we have Git on the local machine
if [[ ! -f "$GIT_BIN" ]]; then
    echo "Git is not installed! Please install with apt-get install git first"
    exit 255
fi

# Check if .ssh directory exists, if not create it
if [[ ! -d "$CLONE_BASE_PATH" ]]; then
    mkdir -p "$CLONE_BASE_PATH"
else
    echo "-> .ssh directory exists for current user $USER"
fi

# Check if SSHKeys directory already exists
if [ -d "$CLONE_PATH" ]; then
    if [ -d "$CLONE_PATH/.git" ] || "$GIT_BIN -C $CLONE_PATH" rev-parse --git-dir > /dev/null 2>&1; then
        echo "-> Directory already exists and is a Git repo, will update from master repo instead"
        bash "$CRONTAB_SCRIPT"
    else
        echo "X> $CLONE_PATH directory exists and is NOT a git repo"
        echo "ERROR: Please fix this manually by removing the existing SSHKeys directory"
        echo "       You can run the following command to do it but make sure you know what your doing!"
        echo "rm -Rf $CLONE_PATH"
        exit 253
    fi
else
    echo "-> Cloning repository into $CLONE_PATH"
    "$GIT_BIN" clone --quiet "$REPO_URL" "$CLONE_PATH" || echo "X> Failed to clone repo!"; exit 3
fi

if [ -f "$AUTHORIZED_KEYS_FILE" -o -h "$AUTHORIZED_KEYS_FILE" ]; then
    if [ -h "$AUTHORIZED_KEYS_FILE" ]; then
        existing_symlink=`readlink "$AUTHORIZED_KEYS_FILE"`
        if [[ "$existing_symlink" == "$REPO_AUTHORIZED_KEYS_FILE" ]]; then
            echo "-> Authorized Keys file already exists and is the correct symolic link"      
        else
            echo "X> Authorized Keys file already exists and is a symbolic link pointing to $existing_symlink"
            echo "ERROR: I don't know how to deal with this, please manaually create the link using this command and re-run the install"
            echo "  ln -s\"$REPO_AUTHORIZED_KEYS_FILE\" \"$AUTHORIZED_KEYS_FILE\""
            exit 254
        fi
    elif [ -f "$AUTHORIZED_KEYS_FILE" ]; then
        if [ -f "$AUTHORIZED_KEYS_FILE.bak" ]; then
            echo "X> It looks like there is already an authorized keys file and also an existing backup"
            echo "ERROR: I don't know how to deal with this, please either removing the existing authorized key file or the backup (.bak) file"
            exit 250
        fi
        BAKNAME=`basename "$AUTHORIZED_KEYS_FILE"`
        echo "-> Authorized Keys file already exists, baking up to $BAKNAME.bak"
        mv "$AUTHORIZED_KEYS_FILE" "$AUTHORIZED_KEYS_FILE.bak"
    else
        echo "X> It seems like the authorized key file already exists but is in a format we cannot understand"
        echo "ERROR: I don't know how to deal with this, please manaually create the link using this command and re-run the install"
        echo "  ln -s\"$REPO_AUTHORIZED_KEYS_FILE\" \"$AUTHORIZED_KEYS_FILE\""
        exit 254
    fi
else
    echo "-> Setting up symbolic link for Authorized Keys file"
    ln -s "$REPO_AUTHORIZED_KEYS_FILE" "$AUTHORIZED_KEYS_FILE"
fi

echo "-> Setup successfully installed SSHKeys"

cron_installed=`crontab -l | grep -q "^$CRON_JOB$"; echo $?`

if [ $cron_installed -ne 0 ]; then
    if [ $(confirm "Would you like to install the update script into crontab for automated updating? [Y/n]"; echo $?) -eq 0 ]; then
        echo "-> Setup automatic updating in crontab"
        # Add to crontab with no duplication
        ( crontab -l | grep -v "$CRON_CMD" ; echo "$CRON_JOB" ) | crontab -
    else
        echo "-> crontab is not setup"
        echo
        echo "You have chosen not to setup crontab, that means you must run the script manually to update your SSHKeys, you can run it using the following command"
        echo "  bash $CRONTAB_SCRIPT"
    fi
else
    echo "Looks like the script is already installed in crontab!"
    if [ $(confirm "Would you like to remove it? [y/N]"; echo $?) -eq 0 ]; then
        echo "-> Removed automatic update script from crontab"
        # Remove it from crontab
        ( crontab -l | grep -v "$CRON_JOB" ) | crontab -

        echo
        echo "If you change your mind later you can add the following to crontab"
        echo "@daily $CRONTAB_SCRIPT"
    fi
fi

echo
echo "Hooray! Everything is setup now"

exit 0

