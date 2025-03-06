#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Registering Syncthing as a user service..."

# Ensure the Syncthing service file exists
SERVICE_FILE="./syncthing/etc/linux-systemd/user/syncthing.service"
USER_SERVICE_DIR="$HOME/.config/systemd/user"
DEST_SERVICE_FILE="$USER_SERVICE_DIR/syncthing.service"

if [[ ! -f $SERVICE_FILE ]]; then
  echo "ERROR: Syncthing service file not found at $SERVICE_FILE"
  exit 1
fi

# Create the systemd directory if it doesn't exist
mkdir -p "$USER_SERVICE_DIR"

# Copy the service file to the user's systemd directory
cp "$SERVICE_FILE" "$DEST_SERVICE_FILE"
echo "Copied service file to $DEST_SERVICE_FILE"

# Get the absolute path to the Syncthing binary
SYNCTHING_BINARY="$(realpath ./syncthing/syncthing)"
if [[ ! -x "$SYNCTHING_BINARY" ]]; then
  echo "ERROR: Syncthing binary not found or is not executable at $SYNCTHING_BINARY"
  exit 1
fi

# Define the default ExecStart pattern to search for
DEFAULT_EXECSTART="ExecStart=/usr/bin/syncthing"

# Extract original parameters after the DEFAULT_EXECSTART
ORIGINAL_PARAMS=$(grep "^$DEFAULT_EXECSTART" "$DEST_SERVICE_FILE" | cut -d' ' -f2-)

# Replace the DEFAULT_EXECSTART line with the actual binary path and preserved parameters
sed -i "s|^$DEFAULT_EXECSTART.*|ExecStart=$SYNCTHING_BINARY $ORIGINAL_PARAMS|" "$DEST_SERVICE_FILE"
echo "Updated ExecStart line in $DEST_SERVICE_FILE to: ExecStart=$SYNCTHING_BINARY $ORIGINAL_PARAMS"

# Reload systemd user daemon to recognize the new service
systemctl --user daemon-reload

# Enable the Syncthing service
systemctl --user enable syncthing.service

# Check if the service is enabled
if systemctl --user is-enabled --quiet syncthing.service; then
  echo "Syncthing service is successfully enabled."
else
  echo "ERROR: Failed to enable Syncthing service!"
  exit 1
fi
