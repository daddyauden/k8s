#!/usr/bin/env sh
set -e

NS=$ARGO_NS

helm uninstall argo-rollouts -n $NS
