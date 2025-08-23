#!/usr/bin/env sh
set -e

helm uninstall redis

kubectl delete secret redis-secrets
