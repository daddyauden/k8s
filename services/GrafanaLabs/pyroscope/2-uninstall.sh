#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall pyroscope -n $NS

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^data-pyroscope' | xargs -I {} kubectl -n $NS delete pvc {}
