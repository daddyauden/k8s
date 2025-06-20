#!/usr/bin/env sh
set -e

cd /tmp

git clone --single-branch --branch v1.17.4 https://github.com/rook/rook.git
cd rook/deploy/examples
kubectl apply -f crds.yaml -f common.yaml -f operator.yaml
kubectl apply -f cluster.yaml
