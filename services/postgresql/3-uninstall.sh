#!/usr/bin/env sh
set -e

NS=prod-mock

helm uninstall postgresql -n $NS

kubectl delete secret postgres-secrets -n $NS
