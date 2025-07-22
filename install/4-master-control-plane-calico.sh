#!/usr/bin/env bash
set -e

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/operator-crds.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/tigera-operator.yaml

kubectl create -f custom-resources.yaml

kubectl get pods -n calico-system

sleep 1m

# fix pod can not conmunicate svc, after remove kube-dns, k8s will recreate it
kubectl delete pods -n kube-system -l k8s-app=kube-dns
