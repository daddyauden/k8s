#!/usr/bin/env sh
set -e

helm repo add gitlab http://charts.gitlab.io/

helm install gitlab gitlab/gitlab --version 9.3.0 -f values.yaml --set global.hosts.domain="$DOMAIN" --set global.hosts.gitlab.name="gitlab.$DOMAIN" --set global.hosts.minio.name="minio-gitlab.$DOMAIN" --set global.hosts.ssh="gitlab.$DOMAIN"

# after update values.yaml, run it
# helm upgrade gitlab gitlab/gitlab --install -f values.yaml --set global.hosts.domain="$DOMAIN" --set global.hosts.gitlab.name="gitlab.$DOMAIN" --set global.hosts.minio.name="minio-gitlab.$DOMAIN" --set global.hosts.ssh="gitlab.$DOMAIN"
