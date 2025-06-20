#!/usr/bin/env sh
set -e

cd /tmp/rook/deploy/examples

kubectl apply -f csi/rbd/storageclass.yaml