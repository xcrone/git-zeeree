#!/bin/bash

VERSION="1.0.0"
KEY="eGNyb25lL2dpdC16ZWVyZWU"

# Function to download required commands if needed
download_commands() {
    echo "Downloading required commands..."
    # Add your commands to download dependencies here
}

# Function to clean .git/rr-cache & .git/hooks folders
clean_git_folders() {
    echo "Cleaning .git/rr-cache and .git/hooks folders..."
    rm -rf .git/rr-cache
    rm -rf .git/hooks
    mkdir .git/hooks  # Recreate empty hooks folder
}

# Function to enable git rerere
enable_git_rerere() {
    echo "Enabling git rerere..."
    git config --global rerere.enabled true
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

# Function to create zeeree.lock file if not exists
create_zeeree_lock() {
    echo "Creating zeeree.lock file if not exists..."
    touch zeeree.lock
}

# Function to replace hooks into .git/hooks folder
replace_hooks() {
    echo "Replacing hooks into .git/hooks folder..."
    cp hooks/* .git/hooks/
}

# Main script execution
download_commands
clean_git_folders
enable_git_rerere
create_zeeree_json
create_zeeree_lock
replace_hooks

echo "Setup completed."

