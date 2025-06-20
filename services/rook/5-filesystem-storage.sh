#!/usr/bin/env sh
set -e

cd /tmp/rook/deploy/examples

kubectl apply -f filesystem.yaml

kubectl apply -f csi/cephfs/storageclass.yaml