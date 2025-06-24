#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

NS=rook-ceph

kubectl -n $NS patch cephcluster rook-ceph --type merge -p '{"spec":{"cleanupPolicy":{"confirmation":"yes-really-destroy-data"}}}'

kubectl -n $NS delete cephcluster rook-ceph

### waiting 2-10 mins check pods, there is rook-ceph-cleanup-* Job，and status should be Completed
echo "waiting 5 minutes for pod cleanup completed"
sleep 5m
kubectl -n rook-ceph get pods

# kubectl delete -f csi/rbd/storageclass.yaml

# kubectl delete -f csi/cephfs/storageclass.yaml

# kubectl delete -f filesystem.yaml

# kubectl delete -f object.yaml

kubectl delete -f cluster.yaml
kubectl delete -f operator.yaml
kubectl delete -f common.yaml
kubectl delete -f crds.yaml
kubectl delete ns $NS

###### delete data in each worker node ######
# sudo rm -rf /var/lib/rook/*
# sudo rm -rf /var/lib/ceph/*
# sudo rm -rf /etc/ceph
