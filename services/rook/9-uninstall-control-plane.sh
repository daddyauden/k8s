#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

NS=rook-ceph

kubectl -n $NS patch cephcluster rook-ceph --type merge -p '{"spec":{"cleanupPolicy":{"confirmation":"yes-really-destroy-data"}}}'

kubectl -n $NS delete cephcluster rook-ceph

# kubectl delete -f csi/rbd/storageclass.yaml

# kubectl delete -f csi/cephfs/storageclass.yaml

# kubectl delete -f filesystem.yaml

# kubectl delete -f object.yaml

kubectl delete -f cluster.yaml
kubectl delete -f operator.yaml
kubectl delete -f common.yaml
kubectl delete -f crds.yaml
kubectl delete ns $NS
