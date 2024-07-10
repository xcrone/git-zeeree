#!/bin/bash

# Function to create zeeree.lock file if not exists
generate_lock() {
    touch zeeree.lock
}

echo "Refreshing..."

generate_lock

echo "Refreshed."
