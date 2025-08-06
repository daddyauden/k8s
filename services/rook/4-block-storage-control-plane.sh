#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

## for production
# kubectl apply -f csi/rbd/storageclass.yaml

## for test
kubectl apply -f csi/rbd/storageclass-test.yaml

## set k8s default storageclass
kubectl patch storageclass rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'