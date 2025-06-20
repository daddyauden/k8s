#!/usr/bin/env sh
set -e

kubectl apply -f minio-dev.yaml

kubectl port-forward pod/minio 9000 9090 -n minio-dev
