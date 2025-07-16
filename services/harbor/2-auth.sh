#!/usr/bin/env sh
set -e

kubectl create secret docker-registry regcred \
    --docker-server=registry.$DOMAIN \
    --docker-username=$REGISTRY_USERNAME \
    --docker-password=$REGISTRY_PASSWORD \
    --docker-email=$REGISTRY_EMAIL \
    -n $NS

kubectl exec -it -n $NS deploy/gitlab-toolbox -- bash

# gitlab-rails console

# user = User.find_by_username('root')
# user.password = 'YourNewPassword123'
# user.password_confirmation = 'YourNewPassword123'
# user.save!

# exit
