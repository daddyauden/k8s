#!/usr/bin/env sh
set -e

helm uninstall postgresql -n $NS

kubectl delete secret postgres-secrets -n $NS
