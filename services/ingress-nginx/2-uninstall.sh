#!/usr/bin/env sh
set -e

kubectl delete secret tls-domain -n $NS

helm uninstall ingress-nginx -n ingress-nginx
