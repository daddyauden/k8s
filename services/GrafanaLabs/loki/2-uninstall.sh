#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall loki -n $NS

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^storage-loki' | xargs -I {} kubectl -n $NS delete pvc {}