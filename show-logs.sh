#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Checking if Syncthing user service is registered..."

# Check if the Syncthing service is listed and available
if systemctl --user list-unit-files | grep -q "syncthing.service"; then
  echo "Syncthing user service is registered. Displaying logs..."
  journalctl -e --user-unit=syncthing.service
else
  echo "ERROR: Syncthing user service is not registered."
  exit 1
fi
