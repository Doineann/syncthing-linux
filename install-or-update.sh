#!/bin/bash

set -e

# Navigate to the script's directory
cd "$(dirname "$0")"

# GitHub-related variables
GITHUB_USER="syncthing"
GITHUB_REPO="syncthing"
ARTIFACT_PATTERN="syncthing-linux-amd64"

# Determine what the latest version is
echo "Finding latest version..."
ARTIFACT_TAGNAME=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-tag)
ARTIFACT_FILENAME=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-filename)
ARTIFACT_URL=$(./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --show-url)
if [[ -z "$ARTIFACT_TAGNAME" || -z "$ARTIFACT_FILENAME" || -z "$ARTIFACT_URL" ]]; then
  echo "ERROR: Unable to find latest version of Syncthing!"
  exit 1
fi
echo "- found: $ARTIFACT_TAGNAME"

# Check if the latest is the same as the current version
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

# Stop syncthing before updating
echo "Check if already running..."
was_running=0
if pgrep -x "syncthing" > /dev/null; then
  echo "Stopping running Syncthing process..."
  ./stop.sh
  was_running=1
  while pgrep -x "syncthing" > /dev/null; do
    sleep 1
  done
fi

# Removing old version
if [[ -d syncthing ]]; then
  echo "Removing old version..."
  rm -rf syncthing
fi

# Downloading latest artifact
./generic/github-fetch-latest-artifact.sh "$GITHUB_USER" "$GITHUB_REPO" "$ARTIFACT_PATTERN" --download

# Extract
echo "Extracting..."
mkdir -p syncthing
tar -xf "$ARTIFACT_FILENAME" -C syncthing --strip-components=1
echo "$ARTIFACT_TAG" > syncthing/version.txt
rm -f "$ARTIFACT_FILENAME"

# And run it again if it was running previously
if [[ $was_running -eq 1 ]]; then
  ./start.sh
fi

echo
echo "Updated to $ARTIFACT_TAGNAME!"
echo
exit 0
