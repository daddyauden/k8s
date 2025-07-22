#!/usr/bin/env sh
set -e

helm uninstall minio -n $NS

kubectl delete secret minio-secrets -n $NS
