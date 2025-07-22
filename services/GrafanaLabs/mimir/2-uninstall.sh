#!/usr/bin/env sh
set -e

NS=prod-mock

helm uninstall mimir -n $NS

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^storage-mimir' | xargs -I {} kubectl -n $NS delete pvc {}
