#!/bin/bash
#This script will help you configuring a new storage and a network share
#Remember to chmod+x on this file to make it executable

#Installing Transmission
sudo apt-get install transmission-daemon -y

#Configuring Transmission
cd ${mount_point}
mkdir downloads
sudo chmod 777 downloads

sudo /etc/init.d/transmission-daemon stop

#Backup actual configuration
sudo cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.original
sudo nano /etc/transmission-daemon/settings.json

#TODO ask user for changes
#“download-dir”: “/mnt/usbhdd/downloads”,
#…
#“incomplete-dir”: “/mnt/usbhdd/downloads”,
#“incomplete-dir-enabled”: true,
#…
#“rpc-authentication-required”: true,
#“rpc-bind-address”: “0.0.0.0”,
#“rpc-enabled”: true,
#“rpc-password”: “your_password“,
#“rpc-port”: 9091,
#“rpc-url”: “/transmission/”,
#“rpc-username”: “your_username“,
#“rpc-whitelist”: “192.168.0.*”,
#“rpc-whitelist-enabled”: true,
#…

#Restart daemon
sudo /etc/init.d/transmission-daemon start
