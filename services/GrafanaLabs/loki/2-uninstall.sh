#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall loki -n $NS

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^data-loki' | xargs -I {} kubectl -n $NS delete pvc {}
kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep 'loki-minio-0$' | xargs -I {} kubectl -n $NS delete pvc {}