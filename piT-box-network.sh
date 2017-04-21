#!/bin/bash
#This script will help you setting a new static ip address for your device
#Remember to chmod+x on this file to make it executable

#Getting new configuration info from user's input
read -p "Enter new static IP address with CIDR notation routing prefix: " ip_address
read -p "Enter new gateway: " routers
read -p "Enter new DNS: " domain_name_servers

red="\033[0;31m"
nc="\033[0m"

#Creating configuration parameters
configuration_parameters="interface eth0

static ip_address=${ip_address}
static routers=${routers}
static domain_name_servers=${domain_name_servers}"

#Plotting new configuration
red="\033[0;31m"
nc="\033[0m"

printf "${red}--------------------------${nc}\nYour new configuration is:\n${red}--------------------------${nc}\n"
printf "$configuration_parameters\n"
printf "${red}--------------------------${nc}\n${red}--------------------------${nc}\n"

#Getting user confirmation and writing changes to dhcpcd.d file
config_file="/etc/dhcpcd.conf"

read -p "This will override your current settings. Proceed? [Y/n] " answer

case $answer in
    [yY]|[yY])
 sudo echo "$configuration_parameters" >> "$config_file"; sudo ifdown eth0; sudo ifup eth0;
 ;;
 
    [nN]|[nN])
 printf "No changes made to actual configuration\n"
       ;;
esac