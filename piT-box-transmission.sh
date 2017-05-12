#!/bin/bash
#This script will help you configuring a new storage and a network share
#Remember to chmod+x on this file to make it executable

# Configuring Transmission
printf "Where do you want to store your downloads?\n" 
cd /mnt && ls -l
read -p "Please select your drive from the list above: " drive
printf "Setting ${drive} as working directory\n"
cd ${drive}

# Installing Transmission
printf "Installing Transmission...\n"
sudo apt-get install transmission-daemon -y

# Stopping transmission-daemon
printf "Stopping Transmission daemon to continue with configuration...\n"
sudo /etc/init.d/transmission-daemon stop

# Backup actual configuration
printf "Performing backup of actual transmission configuration...\n"
if sudo cp /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.original
then
    printf "Backup performed successfully\n"
else
    printf "Failure, exit status $?\n"
fi

# Getting configuration parameters from user's input
# Download directory
read -p "Would you like to create a download folder[Y] or using an existing one[N]? [Y/n] " answer

case ${answer} in
    [yY]|[yY])
 read -p "Please, name the folder: " download_dir; mkdir ${download_dir}; printf "Downloads will be stored in ${drive}/${download_dir}\n"
 ;;
 
    [nN]|[nN])
 ls -l; read -p "Where do you want to store your downloads? Please type its name from list above: " download_dir 
 ;;
esac

# Incomplete download directory
read -p "Would you like to create an incomplete downloads folder [Y] or using an existing one[N]? [Y/n] " answer

case ${answer} in
    [yY]|[yY])
 read -p "Please, name the folder: " incomplete_dir; mkdir ${incomplete_dir}; printf "Incomplete downloads will be stored in ${drive}/${incomplete_dir}\n"
 ;;
 
    [nN]|[nN])
 ls -l; read -p "Where do you want to store your incomplete downloads? Please type its name from list above: " incomplete_dir 
 ;;
esac

# Other parameters
read -p "What's user you want to use for login? " rpc_username
printf "Type the password for ${rpc_username}: " && read -s rpc_password; printf "\n"
read -p "Select your rpc-whitelist range (for example, 192.168.1.*): " rpc_whitelist

# Creating new configuration strings
# TODO Fix formattation of new lines
config_download_dir="\"download-dir\": \"${download_dir}\","
config_incomplete_dir="\"incomplete-dir\": \"${incomplete_dir}\","
config_rpc_password="\"rpc-password\": \"${rpc_password}\","
config_rpc_username="\"rpc-username\": \"${rpc_username}\","
config_rpc_whitelist="\"rpc-whitelist\": \"${rpc_whitelist}\","

# Write changes to transmission config file
transmission_config_file="/etc/transmission-daemon/settings.json"

sudo sed -i '/'\"download-dir\":'/'c'\'"${config_download_dir}" "$transmission_config_file"
sudo sed -i '/'\"incomplete-dir\":'/'c'\'"${config_incomplete_dir}" "$transmission_config_file"
sudo sed -i '/'\"rpc-password\":'/'c'\'"${config_rpc_password}" "$transmission_config_file"
sudo sed -i '/'\"rpc-username\":'/'c'\'"${config_rpc_username}" "$transmission_config_file"
sudo sed -i '/'\"rpc-whitelist\":'/'c'\'"${config_rpc_whitelist}" "$transmission_config_file"

# Restarting daemon
printf "Restarting Transmission...\n"
sudo /etc/init.d/transmission-daemon start

# Final message
printf "Done! Enjoy your piT-box!\n"