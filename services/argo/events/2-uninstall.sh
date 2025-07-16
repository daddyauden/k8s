#!/usr/bin/env sh
set -e

helm uninstall argo-events -n $NS
