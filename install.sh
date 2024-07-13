#!/bin/bash

COMMAND_NAME="zeeree"
COMMAND_LINK="/usr/local/bin"
LIB_DIR="/usr/local/lib/xcrone/git-zeeree"
REPO="https://github.com/xcrone/git-zeeree.git"

run_command() {
    if ! sudo "$@" > /dev/null 2>&1; then
        echo "Error: Failed to execute $1" >&2
        exit 1
    fi
}

download_repo() {
    run_command rm -rf $LIB_DIR
    run_command git clone $REPO $LIB_DIR
}

link_command() {
    if ! run_command rm -f "${COMMAND_LINK}/${COMMAND_NAME}"; then
        echo "Error: Failed to remove existing symbolic link" >&2
        exit 1
    fi

    if ! run_command ln -s "${LIB_DIR}/${COMMAND_NAME}" $COMMAND_LINK; then
        echo "Error: Failed to create symbolic link" >&2
        exit 1
    fi
}

echo "Installing..."

set -u
download_repo
link_command

echo "Completed."
