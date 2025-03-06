#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

echo "Unregistering Syncthing as a user service..."

# Check if the Syncthing service exists
if systemctl --user list-unit-files | grep -q "syncthing.service"; then
  # Stop the Syncthing service if it's running
  if systemctl --user is-active --quiet syncthing.service; then
    echo "Stopping Syncthing service..."
    systemctl --user stop syncthing.service
    if [[ $? -eq 0 ]]; then
      echo "Syncthing service stopped successfully."
    else
      echo "ERROR: Failed to stop Syncthing service!"
      exit 1
    fi
  else
    echo "Syncthing service is not running."
  fi

  # Disable the Syncthing service
  echo "Disabling Syncthing service..."
  systemctl --user disable syncthing.service
  if [[ $? -eq 0 ]]; then
    echo "Syncthing service disabled successfully."
  else
    echo "ERROR: Failed to disable Syncthing service!"
    exit 1
  fi

  # Remove the Syncthing service file
  SERVICE_FILE_PATH="$HOME/.config/systemd/user/syncthing.service"
  if [[ -f $SERVICE_FILE_PATH ]]; then
    echo "Removing Syncthing service file..."
    rm "$SERVICE_FILE_PATH"
    echo "Syncthing service file removed successfully."
  else
    echo "Syncthing service file not found; nothing to remove."
  fi

  # Reload systemd user daemon to finalize changes
  echo "Reloading systemd daemon..."
  systemctl --user daemon-reload

  echo "Syncthing service unregistered successfully."
else
  echo "Syncthing service is not registered as a user service."
fi

exit 0
