#!/usr/bin/env sh
set -e

NS=prod-mock

helm uninstall redis -n $NS

kubectl delete secret redis-secrets -n $NS
