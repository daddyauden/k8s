#!/usr/bin/env sh
set -e

REDIS_PASSWORD=$(kubectl get secret --namespace $NS redis-secrets -o jsonpath="{.data.redis-password}" | base64 -d)

echo $REDIS_PASSWORD

kubectl run --namespace $NS redis-client --restart='Never' --env REDIS_PASSWORD=$REDIS_PASSWORD  --image docker.io/bitnami/redis:8.0.2-debian-12-r4 --command -- sleep infinity

kubectl exec -it redis-client --namespace $NS -- bash

# proxy
# kubectl port-forward --namespace $NS svc/redis 6379:6379 &
# REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h 127.0.0.1 -p 6379

# Auth
# Read only operations
# REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h redis -p 6379


# # Sentinel access
# REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h redis -p 26379

# after login redis, commands for debug
# sentinel get-master-addr-by-name mymaster
# sentinel masters
# sentinel replicas mymaster
# sentinel sentinels mymaster
# sentinel is-master-down-by-addr ${master node ip} 6379
# sentinel config

## failover master(do not use, just for debug in non-prod enviroment)
# sentinel failover mymaster