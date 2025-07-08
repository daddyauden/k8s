#!/usr/bin/env sh
set -e

helm uninstall redis -n $NS

kubectl delete secret redis-secrets -n $NS
