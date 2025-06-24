#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

kubectl apply -f csi/rbd/storageclass.yaml