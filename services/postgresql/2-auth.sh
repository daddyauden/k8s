#!/usr/bin/env sh
set -e

# connect primary
kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace $NS --image docker.io/bitnami/postgresql:17.5.0-debian-12-r16 -- bash

kubectl -n $NS exec -it postgresql-client -- bash
psql -U postgres --host postgresql -p 5432
