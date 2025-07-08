#!/usr/bin/env sh
set -e

kubectl -n $NS delete ingress jenkins-ingress

helm uninstall jenkins -n $NS

kubectl delete secret jenkins-secrets -n $NS
