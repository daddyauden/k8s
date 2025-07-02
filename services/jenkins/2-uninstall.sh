#!/usr/bin/env sh
set -e

NS=prod-mock

kubectl delete -f ingress.yaml

helm uninstall jenkins -n $NS

kubectl delete secret jenkins-secrets -n $NS
