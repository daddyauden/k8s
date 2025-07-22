#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall tempo -n $NS
