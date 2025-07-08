#!/usr/bin/env sh
set -e


helm uninstall gitlab -n $NS

kubectl -n $NS get secrets --no-headers -o custom-columns=":metadata.name" | grep '^gitlab-' | xargs -I {} kubectl -n $NS delete secret {}
