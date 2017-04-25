#!/bin/bash
#This script will help you configuring a new storage and a network share
#Remember to chmod+x on this file to make it executable

#Configuring Transmission
#TODO prompt user for choosing folder
printf "Where do you want to store you downloads?\n" 
cd /mnt && ls -l
read -p "Please select you drive from the list above: " drive
printf "Set ${drive} as working directory\n"
cd ${drive}

#Installing Transmission
printf "Installing Transmission..."
sudo apt-get install transmission-daemon -y

#Stopping transmission-daemon
printf "Stopping Transmission daemon to continue with configuration...\n"
sudo /etc/init.d/transmission-daemon stop

#Backup actual configuration
printf "Performing backup of actual transmission configuration...\n"
if sudo cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.original
then
    printf "Backup performed successfully\n"
else
    printf "Failure, exit status $?\n"
fi

#Getting configuration parameters from user's input

read -p "Would you like to create a download folder or using an existing one? [Y/n] " answer

case ${answer} in
    [yY]|[yY])
 read -p "Please, name the folder: " download_dir; mkdir ${download_dir}; printf "Downloads will be stored in ${drive}/${download_dir}\n"
 ;;
 
    [nN]|[nN])
 ls -l; read -p "Where do you want to store your downloads? " download_dir 
 ;;
esac

read -p "Where do you want to store your incomplete downloads? " incomplete_dir
mkdir ${incomplete_dir}

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
