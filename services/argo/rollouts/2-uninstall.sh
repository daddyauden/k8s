#!/usr/bin/env sh
set -e

helm uninstall argo-rollouts -n $NS
