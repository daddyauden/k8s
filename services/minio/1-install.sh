#!/usr/bin/env sh
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

NS=prod-mock

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

ACCESS_KEY=$(openssl rand -hex 12)
SECRET_KEY=$(openssl rand -hex 32)

echo $ACCESS_KEY #b05c00279ecab4f560988836
echo $SECRET_KEY #12cb9a13a2c21903c84efb2bcf66bbb45613305e33bbf0f1e9616a4915505e4a

kubectl create secret generic minio-secrets \
  --from-literal=accesskey=$ACCESS_KEY \
  --from-literal=secretkey=$SECRET_KEY \
  -n $NS

helm install minio bitnami/minio --version 17.0.9 --namespace $NS --create-namespace -f values.yaml

envsubst < ingress.yaml | kubectl apply -f -

# after update values.yaml, run it
# helm upgrade minio bitnami/minio --install --namespace $NS --create-namespace -f values.yaml --set global.defaultStorageClass=rook-ceph-block

# export ROOT_USER=$(kubectl get secret --namespace prod-mock minio-secrets -o jsonpath="{.data.rootUser}" | base64 -d)
# export ROOT_PASSWORD=$(kubectl get secret --namespace prod-mock minio-secrets -o jsonpath="{.data.rootPassword}" | base64 -d)

# kubectl run --namespace prod-mock minio-client \
#      --rm --tty -i --restart='Never' \
#      --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
#      --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
#      --env MINIO_SERVER_HOST=minio \
#      --image docker.io/bitnami/minio-client:2025.5.21-debian-12-r6 -- admin info minio