#!/bin/bash

VERSION="1.0.0"
KEY="eGNyb25lL2dpdC16ZWVyZWU"

# Function to check if inside Git repository
check_git_repository() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not inside a Git repository. Aborting script."
        exit 1
    fi
}

# Function to clean .git/rr-cache & .git/hooks folders
clean_git_folders() {
    echo "Cleaning folders..."
    mkdir -p .git/rr-cache
    mkdir -p .git/hooks
}

# Function to enable git rerere
enable_git_rerere() {
    echo "Enabling git rerere..."
    git config --local rerere.enabled true
}

# Function to create zeeree.json file if not exists
create_zeeree_json() {
    echo "Creating zeeree.json file if not exists..."
    if [ ! -f ./zeeree.json ]; then
        cp ./config/zeeree.json .
    fi
}

# Function to replace hooks into .git/hooks folder
replace_hooks() {
    echo "Replacing hooks into .git/hooks folder..."
    cp ./hooks/post-merge ./.git/hooks/
    cp ./hooks/post-rebase ./.git/hooks/
}

set_hooks_executable() {
    echo "Grant execute permission to hooks..."
    chmod +x ./.git/hooks/post-merge
    chmod +x ./.git/hooks/post-rebase
}

# Function to refresh zeeree.lock file
refresh_lock() {
    chmod +x ./scripts/after-resolve.sh
    zeeree refresh
}

# Main script execution
check_git_repository
clean_git_folders
enable_git_rerere
create_zeeree_json
replace_hooks
set_hooks_executable
refresh_lock

echo "Setup completed."

