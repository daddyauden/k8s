#!/usr/bin/env sh
set -e

NS=$ARGO_NS

helm uninstall argo-cd -n $NS

kubectl -n $NS get secrets --no-headers -o custom-columns=":metadata.name" | grep '^argocd' | xargs -I {} kubectl -n $NS delete secrets {}

kubectl -n $NS get cm --no-headers -o custom-columns=":metadata.name" | grep '^argocd' | xargs -I {} kubectl -n $NS delete cm {}
