#!/usr/bin/env sh
set -e

######## all worker node ###########
# purge meta and data
sudo wipefs --all /dev/sdb
sudo sgdisk --zap-all /dev/sdb
sudo dd if=/dev/zero of=/dev/sdb bs=4M count=100


### if have multi disk
# sudo wipefs --all /dev/sdc
# sudo sgdisk --zap-all /dev/sdc
# sudo dd if=/dev/zero of=/dev/sdc bs=4M count=100
