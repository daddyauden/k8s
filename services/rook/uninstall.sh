#!/usr/bin/env sh
set -e

cd /gluster/app/github/rook/deploy/examples

NS=rook-ceph

kubectl -n $NS patch cephcluster rook-ceph --type merge -p '{"spec":{"cleanupPolicy":{"confirmation":"yes-really-destroy-data"}}}'

# kubectl delete -f csi/rbd/storageclass.yaml

# kubectl delete -f csi/cephfs/storageclass.yaml

# kubectl delete -f filesystem.yaml

# kubectl delete -f object.yaml

kubectl delete -n $NS cephcluster rook-ceph

kubectl delete -f cluster.yaml -n $NS
kubectl delete -f crds.yaml -f common.yaml -f operator.yaml -n $NS

# delete data path in each worker node
sudo rm -rf /var/lib/rook/*
sudo rm -rf /var/lib/ceph/*
sudo rm -rf /etc/ceph
