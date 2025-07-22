#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall alloy -n $NS

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^storage-mimir' | xargs -I {} kubectl -n $NS delete pvc {}
