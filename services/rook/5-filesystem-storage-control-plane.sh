#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

## for production
# kubectl apply -f filesystem.yaml

## for test
kubectl apply -f filesystem-test.yaml

kubectl apply -f csi/cephfs/storageclass.yaml