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

# Function to download required dependencies if needed
install_dependencies() {
    echo "Install required dependencies..."
    # install
}

# Function to clean .git/rr-cache & .git/hooks folders
clean_git_folders() {
    echo "Cleaning folders..."
    rm -rf .git/rr-cache
    mkdir .git/rr-cache
    rm -rf .git/hooks
    mkdir .git/hooks
}

# Function to enable git rerere
enable_git_rerere() {
    echo "Enabling git rerere..."
    git config --local rerere.enabled true
}

# Function to create zeeree.json file if not exists
create_zeeree_json() {
    echo "Creating zeeree.json file if not exists..."
    if [ ! -f zeeree.json ]; then
        # Define your variable here
        key_value="your_key_value_here"

        # Create zeeree.json with proper formatting
        echo '{
    "version": "'"$VERSION"'",
    "enable": true,
    "key": "'"$KEY"'",
    "days_limit": {
        "enable": true,
        "unresolve": 30,
        "resolve": 30
    }
}' > zeeree.json
    fi
}

# Function to replace hooks into .git/hooks folder
replace_hooks() {
    echo "Replacing hooks into .git/hooks folder..."
    cp hooks/* .git/hooks/
}

# Function to refresh zeeree.lock file
refresh_lock() {
    chmod +x ./scripts/refresh.sh
    ./scripts/refresh.sh
}

# Main script execution
check_git_repository
install_dependencies
clean_git_folders
enable_git_rerere
create_zeeree_json
replace_hooks
refresh_lock

echo "Setup completed."

