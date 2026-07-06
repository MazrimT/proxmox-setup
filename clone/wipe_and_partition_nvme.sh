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
sudo parted /dev/nvme0n1 -s \
  mklabel msdos \
  mkpart primary fat32 1MiB 513MiB \
  mkpart primary ext4 513MiB 65537MiB \
  mkpart primary 65537MiB 100% \
  set 1 boot on

echo "########## Setting up filesystem ##########"
sudo mkfs.vfat -F 32 /dev/nvme0n1p1 -V
sudo mkfs.ext4 -F /dev/nvme0n1p2 -V

# nvme0n1p3 is left unformatted on purpose — Ceph (BlueStore) uses the raw
# partition directly.