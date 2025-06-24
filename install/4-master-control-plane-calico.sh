#!/usr/bin/env bash
set -e

kubectl apply -f calico.yaml

kubectl get pods -n kube-system | grep calico
