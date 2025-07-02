#!/usr/bin/env sh
set -e

helm repo add jenkins https://charts.jenkins.io

helm repo update

NS=prod-mock

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

kubectl create secret generic jenkins-secrets --from-literal=jenkins-username=jenkins-admin --from-literal=jenkins-password=jenkins-admin -n $NS

helm install jenkins jenkins/jenkins --version 5.8.64 --namespace $NS --create-namespace -f values.yaml

kubectl apply -f ingress.yaml

# after update values.yaml, run it
# helm upgrade jenkins jenkins/jenkins --install --namespace $NS --create-namespace -f values.yaml --set global.defaultStorageClass=rook-ceph-block
