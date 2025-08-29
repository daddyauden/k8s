#!/usr/bin/env sh
set -e

NS=apps

helm uninstall wordpress -n $NS

kubectl delete secret wordpress-secret -n $NS