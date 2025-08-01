#!/usr/bin/env sh
set -e

######## all worker node ###########
## check which disk

DISK="sda3 sda4 sda5"

for device in $DISK; do
    sudo sgdisk --zap-all /dev/$device
    sudo wipefs -a --force /dev/$device
    sudo dd if=/dev/zero of=/dev/$device bs=1M count=1000 oflag=direct,dsync
done

lsblk -f
blkid
