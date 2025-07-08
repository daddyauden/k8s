#!/usr/bin/env sh
set -e

NS=prod-mock

kubectl -n $NS delete ingress minio-s3-ingress

kubectl -n $NS delete ingress minio-console-ingress

helm uninstall minio -n $NS

kubectl delete secret minio-secrets -n $NS
