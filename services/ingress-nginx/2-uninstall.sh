#!/usr/bin/env sh
set -e

helm uninstall ingress-nginx -n ingress-nginx
