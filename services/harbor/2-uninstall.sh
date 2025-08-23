#!/usr/bin/env sh
set -e

helm uninstall harbor

kubectl delete secret harbor-secrets

kubectl delete secret regcred

kubectl get pvc --no-headers -o custom-columns=":metadata.name" | grep '^harbor-' | xargs -I {} kubectl delete pvc {}

kubectl get pvc --no-headers -o custom-columns=":metadata.name" | grep '^data-harbor-' | xargs -I {} kubectl delete pvc {}