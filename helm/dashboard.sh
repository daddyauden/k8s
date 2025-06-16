#!/usr/bin/env bash
set -e

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --namespace kubernetes-dashboard \
  --create-namespace \
  -f values/dashboard.yaml

kubectl create serviceaccount admin-user -n kubernetes-dashboard

kubectl create clusterrolebinding admin-user-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:admin-user

kubectl -n kubernetes-dashboard create token admin-user

# helm delete kubernetes-dashboard --namespace kubernetes-dashboard
