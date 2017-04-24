#!/bin/bash

# Getting mount dir
read -p "How do you want to call the mount point directory?" mp_name
sudo mkdir -p /mnt/${mp_name}

# Getting dev
read -p "Which is the /dev drive? (Usually is sda1)" dev_name

# Setting owner and permissions
sudo chown -R pi:pi /mnt/${mp_name}
sudo chmod -R 775 /mnt/${mp_name}

# Setting future permissions
sudo setfacl -Rdm g:pi:rwx /mnt/${mp_name}
sudo setfacl -Rm g:pi:rwx /mnt/${mp_name}

# Installing ntfs-3g to support ntfs filesystem
sudo apt-get install ntfs-3g -y

# Mounting drive
sudo mount -o uid=pi,gid=pi /dev/${dev_name} /mnt/${mp_name}

# Configuring auto mount
sudo apt-get remove usbmount --purge

# Getting UUID and writing config line to /etc/fstab
uuid=$(blkid -o value -s UUID /dev/{dev_name})

echo "Paste this line in /etc/fstab (sudo nano /etc/fstab)\n"
sudo echo "UUID=${uuid}    /mnt/${mp_name} ntfs    nofail,uid=pi,gid=pi    0   0\n" >> /etc/fstab

# Mount all and reboot
sudo mount -a

#Rebooting machine
echo "Rebooting system in"
for i in {5..1}; do printf "$i..\n" && sleep 1; done && sudo reboot