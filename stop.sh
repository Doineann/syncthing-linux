#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Stopping Syncthing..."

# Check if Syncthing is running as a user service
if systemctl --user is-active --quiet syncthing.service; then
  echo "Stopping Syncthing user service..."
  systemctl --user stop syncthing.service
  if [[ $? -eq 0 ]]; then
    echo "Syncthing user service stopped successfully."
    exit 0
  else
    echo "ERROR: Failed to stop Syncthing user service!"
    exit 1
  fi
fi

# Check if Syncthing is running manually
if pgrep -x "syncthing" > /dev/null; then
  echo "Stopping manually started Syncthing process..."
  ./syncthing/syncthing cli operations shutdown
  if [[ $? -eq 0 ]]; then
    echo "Syncthing manually started process stopped successfully."
    exit 0
  else
    echo "ERROR: Failed to stop manually started Syncthing process!"
    exit 1
  fi
else
  echo "Syncthing is not running."
  exit 0
fi
