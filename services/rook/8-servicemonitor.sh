#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples/monitoring

kubectl create -f service-monitor.yaml
kubectl create -f exporter-service-monitor.yaml
kubectl create -f prometheus.yaml
kubectl create -f prometheus-service.yaml