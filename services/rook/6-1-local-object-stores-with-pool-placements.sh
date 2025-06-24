#!/usr/bin/env sh
set -e

cd /gluster/app/github/rook/deploy/examples

kubectl apply -f ./pool-placements.yaml