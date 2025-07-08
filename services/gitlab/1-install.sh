#!/usr/bin/env sh
set -e

helm repo add gitlab http://charts.gitlab.io/

helm repo update

NS=prod-mock

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
    aws_access_key_id: b05c00279ecab4f560988836
    aws_secret_access_key: 12cb9a13a2c21903c84efb2bcf66bbb45613305e33bbf0f1e9616a4915505e4a
    endpoint: https://s3.$DOMAIN
    path_style: true
EOF

helm install gitlab gitlab/gitlab --version 9.1.1 --namespace $NS --create-namespace -f values.yaml --set domain="$DOMAIN"

# after update values.yaml, run it
# helm upgrade gitlab gitlab/gitlab --install --namespace $NS --create-namespace -f values.yaml --set global.defaultStorageClass=rook-ceph-block
