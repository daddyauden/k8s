#!/usr/bin/env sh
set -e

NS=ingress-nginx

kubectl delete secret tls-domain -n prod-mock

helm uninstall ingress-nginx -n $NS
