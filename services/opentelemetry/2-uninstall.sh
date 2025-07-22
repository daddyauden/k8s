#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall otel-collector -n $NS

kubectl get secrets -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^otel' | xargs -I {} kubectl -n $NS delete secrets {}
