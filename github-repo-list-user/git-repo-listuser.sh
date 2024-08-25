#!/bin/bash

# Author: Vijay Saw
# Date: August 25, 2024
# Description: This script lists all users with access to a specified GitHub repository.
# It uses the GitHub API to fetch and display the list of collaborators.

# Prompt the user for their GitHub username and token
echo "Please enter your GitHub username:"
read -r USERNAME

echo "Please enter your GitHub personal access token:"
read -rs TOKEN

# Check if the username or token is empty
if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
    echo "Error: GitHub username and token cannot be empty."
    exit 1
fi

# GitHub API URL
API_URL="https://api.github.com"

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]];
then
    echo "Please specify both repo_owner and repo_name."
    exit 1
fi

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    response=$(curl -s -u "${USERNAME}:${TOKEN}" "$url")

    # Check if curl succeeded
    # Uncomment the following lines if you want to handle curl errors
    # if [[ $? -ne 0 ]]; then
    #     echo "Error: curl command failed."
    #     exit 1
    # fi

    # Check if the response contains an error message (e.g., bad credentials)
    # Uncomment the following lines if you want to handle API errors
    # if echo "$response" | jq -e 'has("message")' > /dev/null; then
    #     echo "Error: $(echo "$response" | jq -r '.message')"
    #     exit 1
    # fi

    # Return the response
    # echo "$response"
}

# Function to list all users with access to the repository
function list_all_users_with_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators=$(github_api_get "$endpoint" | jq -r '.[] | .login')
    # collaborators=$(github_api_get "$endpoint")
    # Display the list of collaborators
    if [[ -z "$collaborators" ]]; then
        echo "No users with access found for ${REPO_OWNER}/${REPO_NAME}, or the repository is private."
    else
        echo "Users with access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi

echo "Listing all users with access to ${REPO_OWNER}/${REPO_NAME}..."
list_all_users_with_access
