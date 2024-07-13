#!/bin/bash

LOCK_FILE="zeeree.lock"
PARENT_DIR=".git/rr-cache"
OUTPUT_DIR=".git/zeeree-temp"
PUSH_COMMIT=false

set_prompt_from_flag() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --push-commit)
                PUSH_COMMIT=true
                ;;
            *)
                echo "Unknown parameter passed: $1"
                exit 1
                ;;
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
        zip -r $ZIP_FILENAME $DIR -x "*.DS_Store"
        HASH=$(cat $ZIP_FILENAME | base64)
        LOCK_CONTENT="${LOCK_CONTENT}${DIR_NAME}:${HASH};"
        if [ "$INDEX" -lt "$TOTAL" ]; then
            LOCK_CONTENT="${LOCK_CONTENT}\n"
        fi
    done
    echo -e $LOCK_CONTENT > $LOCK_FILE
}

push_commit_lock() {
    CURRENT_DATE=$(date +"%Y%m%d%H%M%S")
    git add $LOCK_FILE
    git commit -m "New zeeree generated at $CURRENT_DATE"
    git push -f
}

remove_temp() {
    rm -rf $OUTPUT_DIR
}

set_prompt_from_flag
create_temp
generate_lock
set_lock_content
if $PUSH_COMMIT; then
    push_commit_lock
fi
remove_temp
