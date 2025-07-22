#!/usr/bin/env sh
set -e

######### run the commands in k8s control plane #########

cd github/rook/deploy/examples

kubectl apply -f crds.yaml
kubectl apply -f common.yaml
kubectl apply -f operator.yaml

sleep 1m

kubectl apply -f external/common-external.yaml

# add some spec
#   cephVersion:
#     image: quay.io/ceph/ceph:v17.2.8
#   dataDirHostPath: /var/lib/rook
#   dashboard:
#     enabled: false
#   storage:
#     useAllNodes: false
#     useAllDevices: false
kubectl apply -f external/cluster-external.yaml

# wait 3 mins
sleep 3m

# paste output from 1-export-config-from-ceph-admin-node.sh, the next step depends on it
export ARGS="[Configurations]
namespace = rook-ceph
rgw-pool-prefix = default
format = bash
cephfs-filesystem-name = myfs
cephfs-metadata-pool-name = myfs_metadata
cephfs-data-pool-name = myfs_data
rbd-data-pool-name = replicapool
rgw-endpoint = https://us-east-s3.$DOMAIN:443
skip-monitoring-endpoint = True
rgw-realm-name = america
rgw-zone-name = us-east-a
rgw-zonegroup-name = us-east
"
export NAMESPACE=rook-ceph
export ROOK_EXTERNAL_FSID=68945eb2-536b-11f0-8b39-b578895a0c19
export ROOK_EXTERNAL_USERNAME=client.healthchecker
export ROOK_EXTERNAL_CEPH_MON_DATA=c1=192.168.1.21:6789
export ROOK_EXTERNAL_USER_SECRET=AQDm5F5oxUaDAxAA2Hu3jWzG+zd9NJyd/WAhtg==
export CSI_RBD_NODE_SECRET=AQDm5F5oA0E0BBAAxX9/pQMJQ7sf468YZlDIlQ==
export CSI_RBD_NODE_SECRET_NAME=csi-rbd-node
export CSI_RBD_PROVISIONER_SECRET=AQDm5F5oqUrfBBAAIf1cAZkGju5mQWZZ1QPKbg==
export CSI_RBD_PROVISIONER_SECRET_NAME=csi-rbd-provisioner
export CEPHFS_POOL_NAME=myfs_data
export CEPHFS_METADATA_POOL_NAME=myfs_metadata
export CEPHFS_FS_NAME=myfs
export CSI_CEPHFS_NODE_SECRET=AQDm5F5oPq6OBRAALbvrkbJlwRq+6LMgFmcLPg==
export CSI_CEPHFS_PROVISIONER_SECRET=AQDm5F5oD/YZBhAAVV9Ftp0xbBtlg6CDEoVaqg==
export CSI_CEPHFS_NODE_SECRET_NAME=csi-cephfs-node
export CSI_CEPHFS_PROVISIONER_SECRET_NAME=csi-cephfs-provisioner
export RBD_POOL_NAME=replicapool
export RGW_POOL_PREFIX=default
export RGW_ADMIN_OPS_USER_ACCESS_KEY=5WD2NS8IH4ZFVPT9IABZ
export RGW_ADMIN_OPS_USER_SECRET_KEY=gRhXOpzSrMFksjNMpUv7eESxuFA7iPMd3HYuKC0T

# change default rbd storage class name
export RBD_STORAGE_CLASS_NAME=rook-ceph-block
export CEPHFS_STORAGE_CLASS_NAME=rook-cephfs

# comment RBD_STORAGE_CLASS_NAME and CEPHFS_STORAGE_CLASS_NAME with up new values
chmod +x import-external-cluster.sh

./import-external-cluster.sh

# change k8s default storageclass
kubectl patch storageclass rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'