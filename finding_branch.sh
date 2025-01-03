#!/bin/bash

app_path=(
    "path1/of/the/folder"  # Add as many as you want 
    "path2/of/the/folder"
    "path3/of/the/folder"
    "path4/of/the/folder"
    "path5/of/the/folder"   
)

BRANCH_NAME="clm-addins"

for CLIENT_DIR in "${app_path[@]}"; do
    echo "Checking '$BRANCH_NAME' in directory: $CLIENT_DIR"

    if [ -d "$CLIENT_DIR" ]; then
        cd "$CLIENT_DIR" || { echo "Failed to change directory to $CLIENT_DIR"; continue; }
        if git branch | grep -q "$BRANCH_NAME"; then
            echo "Branch '$BRANCH_NAME' exists."
        else
            echo "Branch '$BRANCH_NAME' does not exist."
        fi
    else
        echo "Directory $CLIENT_DIR does not exist."
    fi

    echo "--------------------------------------"
done

