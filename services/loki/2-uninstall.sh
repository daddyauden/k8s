#!/usr/bin/env sh
set -e

kubectl -n $NS delete ingress loki-minio-console-ingress

helm uninstall loki -n $NS
