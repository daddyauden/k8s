#!/usr/bin/env sh
set -e

# connect primary
kubectl run postgresql-client --rm --tty -i --restart='Never' --image docker.io/bitnami/postgresql:17.5.0-debian-12-r20 -- bash

kubectl exec -it postgresql-client -- bash
psql -U postgres --host postgresql-primary -p 5432
