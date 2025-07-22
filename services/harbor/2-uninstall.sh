#!/usr/bin/env sh
set -e

helm uninstall harbor -n $NS

kubectl delete secret harbor-secrets -n $NS

kubectl delete secret regcred -n $NS
