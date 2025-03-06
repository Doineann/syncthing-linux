#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Opening Syncthing GUI..."
./syncthing/syncthing serve --browser-only
