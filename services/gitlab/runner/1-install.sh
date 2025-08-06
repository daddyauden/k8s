#!/usr/bin/env sh

helm repo add gitlab http://charts.gitlab.io/

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install gitlab-runner gitlab/gitlab-runner --version 0.79.1 --namespace $NS --create-namespace -f values.yaml --set gitlabUrl="https://gitlab.$DOMAIN/" 

# helm upgrade gitlab-runner gitlab/gitlab-runner --namespace $NS --create-namespace -f values.yaml --set gitlabUrl="https://gitlab.$DOMAIN/" 
