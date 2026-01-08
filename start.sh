#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Checking if Syncthing binary exists..."

# Path to the Syncthing binary
SYNCTHING_BINARY="./syncthing/syncthing"

if [[ ! -x "$SYNCTHING_BINARY" ]]; then
  echo "ERROR: Syncthing binary not found or is not executable at $SYNCTHING_BINARY"
  exit 1
fi

echo "Checking if Syncthing user service is available..."

# Check if the Syncthing service is listed and available
if systemctl --user list-unit-files | grep -q "syncthing.service"; then
  echo "Syncthing service is available. Starting the service..."
  systemctl --user start syncthing.service
  if [[ $? -eq 0 ]]; then
    echo "Syncthing service started successfully."
    exit 0
  else
    echo "ERROR: Failed to start Syncthing service!"
    exit 1
  fi
fi

# If the service is not found, start Syncthing manually
echo "Syncthing service not available. Starting Syncthing manually..."
nohup "$SYNCTHING_BINARY" serve --no-browser --no-upgrade --logfile=- > /dev/null 2>&1 &
if [[ $? -eq 0 ]]; then
  echo "Syncthing started manually."
else
  echo "ERROR: Failed to start Syncthing manually!"
  exit 1
fi
