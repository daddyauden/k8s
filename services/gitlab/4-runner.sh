#!/usr/bin/env sh

GITLAB_URL="https://gitlab.$DOMAIN.com/"
REGISTRATION_TOKEN="CUtOPlP4Z9QTu8GJMPCNL33fDnYB3DSlfsxj3CC5gGrrNT7ONWAc0bSegxCbGMFB"
RUNNER_NAME="c5"
RUNNER_TAGS="docker"
RUNNER_EXECUTOR="docker"
DOCKER_IMAGE="docker:latest"

docker pull gitlab/gitlab-runner:latest

docker run -d --name gitlab-runner \
    --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

docker run --rm -it \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner register \
    --non-interactive \
    --url "$GITLAB_URL" \
    --registration-token "$REGISTRATION_TOKEN" \
    --executor "$RUNNER_EXECUTOR" \
    --docker-image "$DOCKER_IMAGE" \
    --description "$RUNNER_NAME" \
    --tag-list "$RUNNER_TAGS" \
    --run-untagged="true" \
    --locked="false"