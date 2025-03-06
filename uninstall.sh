#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Starting full uninstallation of Syncthing..."

# Step 1: Stop Syncthing using stop.sh
./stop.sh

# Step 2: Remove Syncthing as a service using remove-service.sh
./remove-service.sh

# Step 3: Remove the Syncthing folder created by update.sh
SYNCTHING_FOLDER="./syncthing"
if [[ -d $SYNCTHING_FOLDER ]]; then
  echo "Removing Syncthing folder..."
  rm -rf "$SYNCTHING_FOLDER"
  echo "Syncthing folder removed successfully."
else
  echo "Syncthing folder not found; no cleanup needed for the folder."
fi

echo "Uninstallation of Syncthing completed successfully!"
exit 0
