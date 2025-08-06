#!/usr/bin/env sh
set -e

helm repo add gitlab http://charts.gitlab.io/

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
    aws_access_key_id: ead36fa2a638f64ce5c74885
    aws_secret_access_key: 5ef0ebfcb0fd30c02170fb6baba6f6fb82661836407f25751c5ccb13ae1aa0f4
    endpoint: https://s3.$DOMAIN
    path_style: true
EOF

helm install gitlab gitlab/gitlab --version 9.2.1 --namespace $NS --create-namespace -f values.yaml --set global.shell.port=222 --set global.hosts.domain="$DOMAIN" --set global.hosts.gitlab.name="gitlab.$DOMAIN" --set global.hosts.pages.name="pages.$DOMAIN" --set global.hosts.ssh="gitlab.$DOMAIN"

# after update values.yaml, run it
# helm upgrade gitlab gitlab/gitlab --install --namespace $NS --create-namespace -f values.yaml --set global.shell.port=222 --set global.hosts.domain="$DOMAIN" --set global.hosts.gitlab.name="gitlab.$DOMAIN" --set global.hosts.pages.name="pages.$DOMAIN" --set global.hosts.ssh="gitlab.$DOMAIN"
