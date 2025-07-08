#!/usr/bin/env sh
set -e

kubectl exec -it -n $NS deploy/gitlab-toolbox -- bash

# gitlab-rails console

# user = User.find_by_username('root')
# user.password = 'YourNewPassword123'
# user.password_confirmation = 'YourNewPassword123'
# user.save!

# exit
