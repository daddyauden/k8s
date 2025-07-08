#!/usr/bin/env sh
set -e

helm uninstall traefik -n $NS
