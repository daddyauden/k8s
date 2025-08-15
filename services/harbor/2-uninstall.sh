#!/usr/bin/env sh
set -e

helm uninstall harbor -n $NS

kubectl delete secret harbor-secrets -n $NS

# kubectl delete secret regcred -n $NS

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^harbor-' | xargs -I {} kubectl -n $NS delete pvc {}

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^data-harbor-' | xargs -I {} kubectl -n $NS delete pvc {}