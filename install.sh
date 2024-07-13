#!/bin/bash

COMMAND_NAME="zeeree"
COMMAND_LINK="/usr/local/bin"
LIB_DIR="/usr/local/lib/xcrone/git-zeeree"
REPO="https://github.com/xcrone/git-zeeree.git"

run_command() {
    sudo $1 > /dev/null 2>&1
}

echo "Installing..."
set -u

run_command rm -rf $LIB_DIR
run_command git clone $REPO $LIB_DIR

run_command rm -f "${COMMAND_LINK}/${COMMAND_NAME}"
run_command ln -s "${LIB_DIR}/${COMMAND_NAME}" $COMMAND_LINK

echo "Completed."
