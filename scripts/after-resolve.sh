#!/bin/bash

LOCK_FILE="zeeree.lock"
PARENT_DIR=".git/rr-cache"
OUTPUT_DIR=".git/zeeree-temp"
SAVE_COMMIT=false

set_prompt_from_flag() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --save-commit) SAVE_COMMIT=true ;;
        esac
        shift
    done
}

create_temp() {
    mkdir -p $OUTPUT_DIR
}

generate_lock() {
    rm -rf $LOCK_FILE
    touch $LOCK_FILE
}

get_total_child_directory() {
    DIRECTORIES=$(find "$PARENT_DIR" -mindepth 1 -maxdepth 1 -type d | sort)
    if [ -z "$DIRECTORIES" ]; then
        TOTAL=0
    else
        TOTAL=$(echo "$DIRECTORIES" | wc -l)
    fi

    echo $TOTAL
}

set_lock_content() {
    LOCK_CONTENT=$(cat $LOCK_FILE)
    TOTAL=$(get_total_child_directory)
    echo "Total merge conflict and resolve cache: $TOTAL"
    if [ "$TOTAL" -eq 0 ]; then
        return
    fi
    INDEX=0
    for DIR in "$PARENT_DIR"/*/; do
        INDEX=$((INDEX + 1))
        DIR_NAME=$(basename "$DIR")
        ZIP_FILENAME="${OUTPUT_DIR}/${DIR_NAME}.zip"
        zip -r $ZIP_FILENAME $DIR -x "*.DS_Store" > /dev/null 2>&1
        HASH=$(cat $ZIP_FILENAME | base64)
        LOCK_CONTENT="${LOCK_CONTENT}${DIR_NAME}:${HASH};"
        if [ "$INDEX" -lt "$TOTAL" ]; then
            LOCK_CONTENT="${LOCK_CONTENT}\n"
        fi
    done
    echo -e $LOCK_CONTENT > $LOCK_FILE
}

save_commit_lock() {
    CURRENT_DATE=$(date +"%Y%m%d%H%M%S")
    git add $LOCK_FILE
    git commit -m "Zeeree Generated at $CURRENT_DATE"
}

remove_temp() {
    rm -rf $OUTPUT_DIR
}

set_prompt_from_flag "$@"
create_temp
generate_lock
set_lock_content
if $SAVE_COMMIT; then
    save_commit_lock
fi
remove_temp
