#!/usr/bin/env sh
set -e

######## all worker node ###########
## check which disk
lsblk -f
blkid

DISK1=sdc

for device in $DISK1; do
    sudo sgdisk --zap-all /dev/$device
    sudo dd if=/dev/zero of=/dev/$device bs=1M count=1000 oflag=direct,dsync
    sudo wipefs -a --force /dev/$device
done
