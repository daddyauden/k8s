#!/usr/bin/env sh
set -e

NS=prod-mock

kubectl -n $NS delete ingress harbor-ingress
kubectl -n $NS delete ingress harbor-registry-ingress

helm uninstall harbor -n $NS

kubectl delete secret harbor-secrets -n $NS
