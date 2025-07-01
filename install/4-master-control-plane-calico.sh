#!/usr/bin/env bash
set -e

kubectl apply -f calico.yaml

kubectl get pods -n kube-system | grep calico

sleep 1m

# fix pod can not conmunicate svc, after remove kube-dns, k8s will recreate it
kubectl delete pods -n kube-system -l k8s-app=kube-dns
