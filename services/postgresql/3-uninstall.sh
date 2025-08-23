#!/usr/bin/env sh
set -e

helm uninstall postgresql

kubectl delete secret postgres-secrets
