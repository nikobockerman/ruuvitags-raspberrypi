#!/bin/bash

set -xe

cur_dir=$(dirname "$(readlink -f "$0")")
repo_dir="$cur_dir"/repo

cd "$repo_dir"

branch_name=$(git rev-parse --abbrev-ref HEAD)
commit_id=$(git rev-parse --short HEAD)
docker_image_tag="${branch_name}-${commit_id}"

sudo DOCKER_BUILDKIT=1 docker build -t ruuvi-collector:"$docker_image_tag" .
