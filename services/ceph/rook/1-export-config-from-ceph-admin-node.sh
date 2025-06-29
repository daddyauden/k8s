#!/usr/bin/env sh
set -e

######### run the commands from ceph admin node, maybe your k8s control plane host is not the same with ceph admin #########
######### my situation: c5 is control plane, c1 is ceph admin #########

if [ ! -d "github" ]; then
    mkdir ./github
    touch ./github/.gitkeep
fi

cd github

if [ ! -d "rook/deploy/examples" ]; then
    git clone https://github.com/rook/rook.git
fi

cd rook/deploy/examples/external

sudo python3 create-external-cluster-resources.py \
--rbd-data-pool-name replicapool \
--cephfs-filesystem-name myfs \
--rgw-endpoint https://us-east-s3.test.com:443 \
--rgw-realm-name america \
--rgw-zonegroup-name us-east \
--rgw-zone-name us-east-a \
--namespace rook-ceph \
--format bash \
--skip-monitoring-endpoint

######### output look like #########
# export ARGS="[Configurations]
# namespace = rook-ceph
# rgw-pool-prefix = default
# format = bash
# cephfs-filesystem-name = myfs
# cephfs-metadata-pool-name = myfs_metadata
# cephfs-data-pool-name = myfs_data
# rbd-data-pool-name = replicapool
# rgw-endpoint = https://us-east-s3.test.com:443
# skip-monitoring-endpoint = True
# rgw-realm-name = america
# rgw-zone-name = us-east-a
# rgw-zonegroup-name = us-east
# "
# export NAMESPACE=rook-ceph
# export ROOK_EXTERNAL_FSID=68945eb2-536b-11f0-8b39-b578895a0c19
# export ROOK_EXTERNAL_USERNAME=client.healthchecker
# export ROOK_EXTERNAL_CEPH_MON_DATA=c1=192.168.1.21:6789
# export ROOK_EXTERNAL_USER_SECRET=AQDm5F5oxUaDAxAA2Hu3jWzG+zd9NJyd/WAhtg==
# export CSI_RBD_NODE_SECRET=AQDm5F5oA0E0BBAAxX9/pQMJQ7sf468YZlDIlQ==
# export CSI_RBD_NODE_SECRET_NAME=csi-rbd-node
# export CSI_RBD_PROVISIONER_SECRET=AQDm5F5oqUrfBBAAIf1cAZkGju5mQWZZ1QPKbg==
# export CSI_RBD_PROVISIONER_SECRET_NAME=csi-rbd-provisioner
# export CEPHFS_POOL_NAME=myfs_data
# export CEPHFS_METADATA_POOL_NAME=myfs_metadata
# export CEPHFS_FS_NAME=myfs
# export CSI_CEPHFS_NODE_SECRET=AQDm5F5oPq6OBRAALbvrkbJlwRq+6LMgFmcLPg==
# export CSI_CEPHFS_PROVISIONER_SECRET=AQDm5F5oD/YZBhAAVV9Ftp0xbBtlg6CDEoVaqg==
# export CSI_CEPHFS_NODE_SECRET_NAME=csi-cephfs-node
# export CSI_CEPHFS_PROVISIONER_SECRET_NAME=csi-cephfs-provisioner
# export RBD_POOL_NAME=replicapool
# export RGW_POOL_PREFIX=default
# export RGW_ADMIN_OPS_USER_ACCESS_KEY=5WD2NS8IH4ZFVPT9IABZ
# export RGW_ADMIN_OPS_USER_SECRET_KEY=gRhXOpzSrMFksjNMpUv7eESxuFA7iPMd3HYuKC0T
