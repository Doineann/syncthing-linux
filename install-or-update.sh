#!/bin/bash

set -e

# Require elevated privileges
if [ $EUID != 0 ]; then
    echo "This script requires elevated privileges."
    sudo "$0" "$@"
    exit $?
fi

# Navigate to the script's directory
cd "$(dirname "$0")"

# GitHub-related variables
GITHUB_USER="syncthing"
GITHUB_REPO="syncthing"
ARTIFACT_PATTERN="syncthing-linux-amd64"

# Check if Syncthing is running
if pgrep -x "syncthing" > /dev/null; then
    echo "WARNING: Syncthing is currently running. Please stop it before updating."
    exit 1
fi

# Determine what the latest version is
echo "Finding the latest version..."
ARTIFACT_TAGNAME=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-tag)
ARTIFACT_FILENAME=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-filename)
ARTIFACT_URL=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-url)
if [[ -z "$ARTIFACT_TAGNAME" || -z "$ARTIFACT_FILENAME" || -z "$ARTIFACT_URL" ]]; then
    echo "ERROR: Unable to find the latest version of Syncthing!"
    exit 1
fi
echo "- Found: $ARTIFACT_TAGNAME"

# Check if the latest version is already installed
if [[ -f syncthing/version.txt ]]; then
    current_version=$(<syncthing/version.txt)
    current_version=$(echo "$current_version" | xargs) # Trim whitespace
    if [[ "$current_version" == "$ARTIFACT_TAGNAME" ]]; then
        echo
        echo "Latest version already installed!"
        echo
        exit 0
    fi
fi

# Remove the old version
if [[ -d syncthing ]]; then
    echo "Removing old version..."
    rm -rf syncthing
fi

# Download the latest artifact
echo "Downloading latest version..."
./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --download

# Extract the new version
echo "Extracting..."
mkdir -p syncthing
tar -xf "$ARTIFACT_FILENAME" -C syncthing --strip-components=1
echo "$ARTIFACT_TAGNAME" > syncthing/version.txt
rm -f "$ARTIFACT_FILENAME"

echo
echo "Updated to $ARTIFACT_TAGNAME!"
echo
exit 0
