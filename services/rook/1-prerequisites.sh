#!/usr/bin/env sh
set -e

######## all worker node ###########
sudo apt install -y ceph ceph-common ceph-volume

sudo rmmod ceph libceph rbd



# sudo ceph-volume lvm zap /dev/sda --destroy
# sudo ceph-volume raw zap /dev/sda --destroy


# pruge GPT
sudo sgdisk --zap-all /dev/sda
sudo dd if=/dev/zero of=/dev/sda bs=1M count=10000 oflag=direct,dsync
sudo wipefs -a --force /dev/sda


### if have multi disk
# sudo ceph-volume lvm zap /dev/sdc --destroy
# sudo ceph-volume raw zap /dev/sdc --destroy

# pruge GPT
sudo sgdisk --zap-all /dev/sdc
sudo dd if=/dev/zero of=/dev/sdc bs=1M count=10000 oflag=direct,dsync
sudo wipefs -a --force /dev/sdc

sudo pvremove /dev/sda /dev/sdc --force --force
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo partprobe /dev/sda /dev/sdc


# 检查分区表
sudo gdisk -l /dev/sda
sudo gdisk -l /dev/sdc

# 检查文件系统签名
sudo wipefs /dev/sda
sudo wipefs /dev/sdc

# 检查 LVM 信息
sudo pvs
sudo vgs

# blkid