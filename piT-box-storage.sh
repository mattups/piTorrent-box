#!/bin/bash

# Getting mount dir
read -p "How do you want to call the mount point directory? " mp_name
sudo mkdir -p /mnt/${mp_name}

# Getting dev
printf "These are your interfaces: "
lsblk
read -p "Which is the /dev drive? (Usually is sda1): " dev_name

# Setting owner and permissions
printf "Setting owner and permissions...\n"
sudo chown -R pi:pi /mnt/${mp_name}
sudo chmod -R 775 /mnt/${mp_name}

# Setting future permissions
printf "Setting future permissions...\n"
sudo setfacl -Rdm g:pi:rwx /mnt/${mp_name}
sudo setfacl -Rm g:pi:rwx /mnt/${mp_name}

# Installing ntfs-3g to support ntfs filesystem
printf "Installing ntfs-3g...\n"
sudo apt-get install ntfs-3g -y

# Mounting drive
printf "Mounting your new drive...\n"
sudo mount -o uid=pi,gid=pi /dev/${dev_name} /mnt/${mp_name}

# Removing usbmount
printf "Removing usbmount...\n"
sudo apt-get remove usbmount --purge

# Getting UUID and creating UUID config line for /etc/fstab
printf "Getting UUID and creating UUID config line for /etc/fstab...\n"
uuid=$(blkid -o value -s UUID /dev/${dev_name})
uuid_line="UUID=${uuid}    /mnt/${mp_name} ntfs    nofail,uid=pi,gid=pi    0   0"

# Writing config line to /etc/fstab
printf "Writing new configuration into /etc/fstab...\n"
if echo ${uuid_line} | sudo tee -a  /etc/fstab; then
    printf "Successfully appended line to /etc/fstab!\n"
else
    "Failed to write to /etc/fstab, status code $?\n"
fi

# Mount all and reboot
if sudo mount -a; then
    echo "Rebooting system in"
    for i in {5..1}; do printf "$i..\n" && sleep 1; done && sudo reboot
else
    printf "Failed to mount, status code $?\n"
fi