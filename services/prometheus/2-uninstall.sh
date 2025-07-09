#!/usr/bin/env sh
set -e

helm uninstall prometheus -n $NS

kubectl get crd --no-headers -o custom-columns=":metadata.name" | grep 'monitoring.coreos.com$' | xargs -I {} kubectl delete crd {}
