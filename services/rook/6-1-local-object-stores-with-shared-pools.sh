#!/usr/bin/env sh
set -e

cd /gluster/app/github/rook/deploy/examples

kubectl apply -f object-shared-pools.yaml