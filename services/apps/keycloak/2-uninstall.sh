#!/usr/bin/env sh
set -e

NS=apps

helm uninstall keycloak -n $NS

kubectl delete secret keycloak-secret -n $NS