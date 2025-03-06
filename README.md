# syncthing-linux

Some scripts for managing [Syncthing](https://syncthing.net/) on Linux...

### How to use?

- run `update.sh` to download the latest version of syncthing (will extract to .\syncthing)
- use `add-as-service.sh` to run syncthing as service at logon
- use `remove-service.sh` to remove syncthing as service at logon
- use `start.sh` and `stop.sh` to start/stop syncthing manually
- run `open-gui.sh` to open a browser window to the web interface of syncthing
- run `show-logs.sh` to show the logs of syncthing
- run `uninstall.sh` to do a complete uninstallation of syncthing (config will be kept)