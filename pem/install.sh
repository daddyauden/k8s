#!/usr/bin/env sh
set -e

kubectl create secret tls tls-domain --cert=tls.crt --key=tls.key