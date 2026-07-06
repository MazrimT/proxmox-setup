#!/bin/bash

echo "THIS WILL WIPE THE NVME DRIVE COMPLETELY!!!"
read -p "Do you want to proceed? (Y/n) " yn
case $yn in 
	Y ) ;;
        n ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac
 
echo "########## Wiping partitions from drive ##########"
sudo wipefs -a /dev/nvme0n1

echo "########## Setting up boot and root partitions ##########"
sudo parted /dev/nvme0n1 --script \
  mklabel msdos \
  mkpart primary fat32 1MiB 513MiB \
  mkpart primary ext4 513MiB 65537MiB \
  set 1 boot on

echo "########## Setting up filesystem ##########"
sudo mkfs.vfat -F 32 /dev/nvme0n1p1
sudo mkfs.ext4 -F /dev/nvme0n1p2