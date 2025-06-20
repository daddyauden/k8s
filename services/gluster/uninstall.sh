#!/usr/bin/env sh
set -e

sudo systemctl stop glusterd
sudo systemctl disable glusterd
sudo apt-get remove --purge glusterfs-server glusterfs-client glusterfs-common
sudo apt-get autoremove
sudo rm -rf /var/lib/glusterd
sudo rm -rf /etc/glusterfs
sudo rm -rf /var/log/glusterfs
sudo rm -rf /data/glusterfs/*