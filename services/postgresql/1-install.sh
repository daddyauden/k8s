#!/usr/bin/env sh
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami

# key=password for harbor registry database
kubectl create secret generic postgres-secrets \
  --from-literal=password=JMWlHeVNrNXIzSWNxRmp5Mno5ZDRtOTFLb0ZEaUhRko= \
  --from-literal=postgres-password=ZDRtOTFLb0ZEaUhJMWlHeVNrNXIzSWNxRmp5Mno5Rko= \
  --from-literal=gitlab-password=dFBDMlJvRENOT3pibVloU3N4UG9kQ1FSR0k3dHhMOUk= \
  --from-literal=replication-password=MjMxUDg0ZnJiN2NzUmgxeHV6UXpLRHZSWWVubWVQVlc= \

helm install postgresql bitnami/postgresql --version 16.7.21 -f values.yaml

# helm upgrade postgresql bitnami/postgresql --install -f values.yaml
