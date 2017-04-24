#!/bin/bash

# Getting mount dir
read -p "How do you want to call the mount point directory?" mp_name
sudo mkdir -p /mnt/${mp_name}

# Getting dev
printf "These are your interfaces: "
lsblk
read -p "\nWhich is the /dev drive? (Usually is sda1): " dev_name

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

# Getting UUID and creating UUID config line fot /etc/fstab 
uuid=$(blkid -o value -s UUID /dev/{dev_name})
uuid_line="UUID=${uuid}    /mnt/${mp_name} ntfs    nofail,uid=pi,gid=pi    0   0\n"

# Writing config line to /etc/fstab
sudo echo ${uuid_line} >> /etc/fstab

# Mount all and reboot
if sudo mount -a; then
    echo "Rebooting system in"
    for i in {5..1}; do printf "$i..\n" && sleep 1; done && sudo reboot
else
    printf "Failed to mount, status code $?\n"