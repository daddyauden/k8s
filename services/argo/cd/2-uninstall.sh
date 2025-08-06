#!/usr/bin/env sh
set -e

NS=$ARGOCD_NS

helm uninstall argo-cd -n $NS

kubectl get crd --no-headers -o custom-columns=":metadata.name" | grep 'argoproj.io$' | xargs -I {} kubectl delete crd {}

kubectl -n $NS get secrets --no-headers -o custom-columns=":metadata.name" | grep '^argocd' | xargs -I {} kubectl -n $NS delete secrets {}

kubectl -n $NS get cm --no-headers -o custom-columns=":metadata.name" | grep '^argocd' | xargs -I {} kubectl -n $NS delete cm {}
