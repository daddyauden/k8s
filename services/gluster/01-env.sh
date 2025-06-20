#!/usr/bin/env sh
set -e

###################### set in all nodes ######################
sudo apt update
sudo apt install -y glusterfs-server
sudo systemctl enable --now glusterd
sudo mkdir -p /data/glusterfs
sudo chown -R gluster:gluster /data/glusterfs


###################### set in master node c5 ######################
sudo gluster peer probe c1
sudo gluster peer probe c2
sudo gluster peer status
sudo gluster volume create gv0 replica 3 c5:/data/glusterfs c1:/data/glusterfs c2:/data/glusterfs force
sudo gluster volume start gv0
sudo gluster volume info gv0
sudo gluster volume status gv0


###################### set in all nodes ######################
sudo mkdir /mnt/gluster
sudo mount -t glusterfs c5:/gv0 /mnt/gluster


###################### in any node ######################
echo "Hello from $(hostname)" | sudo tee /mnt/gluster/minio/test.txt
