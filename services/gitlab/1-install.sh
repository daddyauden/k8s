#!/usr/bin/env sh
set -e

helm repo add gitlab http://charts.gitlab.io/

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-object-storage
  namespace: $NS
type: Opaque
stringData:
  connection: |
    provider: AWS
    region: us-east-1
    aws_access_key_id: beb8a305683f2dafa8750dbf
    aws_secret_access_key: e177a5d8adf6b5e3522b9d2893d340b093661cdf6f33763318fd47b48f3ba96e
    endpoint: https://s3.$DOMAIN
    path_style: true
EOF

helm install gitlab gitlab/gitlab --version 9.1.1 --namespace $NS --create-namespace -f values.yaml --set global.hosts.domain="$DOMAIN" --set global.hosts.gitlab.name="gitlab.$DOMAIN" --set global.hosts.pages.name="gitlab.$DOMAIN" --set global.hosts.ssh="gitlab.$DOMAIN"

# after update values.yaml, run it
# helm upgrade gitlab gitlab/gitlab --install --namespace $NS --create-namespace -f values.yaml -f values.yaml --set global.hosts.domain="$DOMAIN" --set global.hosts.gitlab.name="gitlab.$DOMAIN" --set global.hosts.pages.name="gitlab.$DOMAIN" --set global.hosts.ssh="gitlab.$DOMAIN"
