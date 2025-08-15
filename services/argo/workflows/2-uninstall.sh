#!/usr/bin/env sh
set -e

NS=$ARGO_NS

kubectl delete clusterrolebinding argo-workflows-team-devops

kubectl delete clusterrole argo-workflows-team-devops

helm uninstall argo-workflows -n $NS

kubectl delete secret argo-server-sso -n $NS

kubectl delete secret argo-workflows-minio -n $NS

kubectl delete secret argo-workflows-team-devops.service-account-token -n $NS

kubectl delete sa argo-workflows-read-only -n $NS

kubectl delete sa argo-workflows-team-devops -n $NS
