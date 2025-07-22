#!/usr/bin/env sh
set -e

helm uninstall jaeger -n $NS

# kubectl delete secret jaeger-secrets -n $NS
