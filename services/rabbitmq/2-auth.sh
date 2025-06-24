#!/usr/bin/env sh
set -e

NS=prod-mock

# Credentials:
# Username
# Username = rabbitmq-admin
# Password
# Password = (kubectl get secret --namespace $NS rabbitmq-secrets -o jsonpath="{.data.rabbitmq-password}" | base64 -d)
# ErLang Cookie
# Cookie = $(kubectl get secret --namespace $NS rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)

kubectl exec -it rabbitmq-0 --namespace $NS -- rabbitmqctl cluster_status

kubectl exec -it rabbitmq-0 --namespace $NS -- rabbitmq-diagnostics cluster_status
