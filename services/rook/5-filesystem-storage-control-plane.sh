#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

kubectl apply -f filesystem.yaml

kubectl apply -f csi/cephfs/storageclass.yaml