#!/usr/bin/env sh
set -e

helm uninstall gitlab

kubectl get secrets --no-headers -o custom-columns=":metadata.name" | grep '^gitlab-' | xargs -I {} kubectl delete secret {}

kubectl get pvc --no-headers -o custom-columns=":metadata.name" | grep '^repo-data-gitlab-' | xargs -I {} kubectl delete pvc {}