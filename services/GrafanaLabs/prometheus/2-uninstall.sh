#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm uninstall prometheus -n $NS

kubectl get crd --no-headers -o custom-columns=":metadata.name" | grep 'monitoring.coreos.com$' | xargs -I {} kubectl delete crd {}

kubectl get secrets -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^alertmanager-prometheus-kube' | xargs -I {} kubectl -n $NS delete secrets {}

kubectl get secrets -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^prometheus' | xargs -I {} kubectl -n $NS delete secrets {}

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^prometheus-prometheus-kube' | xargs -I {} kubectl -n $NS delete pvc {}

kubectl get pvc -n $NS --no-headers -o custom-columns=":metadata.name" | grep '^storage-prometheus-grafana' | xargs -I {} kubectl -n $NS delete pvc {}
