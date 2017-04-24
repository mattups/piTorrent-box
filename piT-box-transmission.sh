#!/bin/bash
#This script will help you configuring a new storage and a network share
#Remember to chmod+x on this file to make it executable

#Installing Transmission
sudo apt-get install transmission-daemon -y

#Configuring Transmission
#TODO prompt user for choosing folder
cd ${mount_point}
mkdir downloads
sudo chmod 777 downloads

#Stop transmission-daemon
sudo /etc/init.d/transmission-daemon stop

#Backup actual configuration
sudo cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.original

#Getting configuration parameters from user's input
read -p "Where do you want to store your downloads? " download_dir 
read -p "Where do you want to store your incomplete downloads? " incomplete_dir
read -p "What's user you want to use for login? " rpc_username
read -p "Password for ${rpc_username}: " rpc_password
read -p "Select your rpc-whitelist range (for example, 192.168.1.*): " rpc_whitelist

config_download_dir="\"download-dir\": \"${download_dir}\","
config_incomplete_dir="\"incomplete-dir\": \"${incomplete_dir}\","
config_rpc_password="\"rpc-password\": \"${rpc_password}\","
config_rpc_username="\"rpc-username\": \"${rpc_username}\","
config_rpc_whitelist="\"rpc-whitelist\": \"${rpc_whitelist}\","

#TODO Write changes to /etc/transmission-daemon/settings.json

#Restart daemon
sudo /etc/init.d/transmission-daemon start
