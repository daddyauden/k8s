#!/usr/bin/env sh
set -e

NS=prod-mock

helm uninstall traefik -n $NS
