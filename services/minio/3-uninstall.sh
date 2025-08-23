#!/usr/bin/env sh
set -e

helm uninstall minio

kubectl delete secret minio-secrets
