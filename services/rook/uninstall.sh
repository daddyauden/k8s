#!/usr/bin/env sh
set -e

cd /tmp/rook/deploy/examples

kubectl -n rook-ceph patch cephcluster rook-ceph --type merge -p '{"spec":{"cleanupPolicy":{"confirmation":"yes-really-destroy-data"}}}'
kubectl -n rook-ceph delete cephcluster rook-ceph
kubectl delete -f crds.yaml -f common.yaml -f operator.yaml
kubectl delete -f cluster.yaml

# delete data path in each worker node
sudo rm -rf /var/lib/rook/
