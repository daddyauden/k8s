#!/usr/bin/env sh
set -e

###### delete data in each worker node ######
sudo rm -rf /var/lib/rook/*
sudo rm -rf /var/lib/ceph/*
sudo rm -rf /etc/ceph
