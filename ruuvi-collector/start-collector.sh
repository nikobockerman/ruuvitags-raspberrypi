#!/bin/bash

set -xe

cur_dir=$(dirname "$(readlink -f "$0")")
repo_dir="$cur_dir"/repo

branch_name=$(git -C "$repo_dir" rev-parse --abbrev-ref HEAD)
commit_id=$(git -C "$repo_dir" rev-parse --short HEAD)
docker_image_tag="${branch_name}-${commit_id}"

sudo docker run \
    -d \
    --name ruuvi-collector \
    --restart unless-stopped \
    --privileged \
    --net=host \
    -v "$cur_dir"/ruuvi-collector.properties:/app/target/ruuvi-collector.properties:ro \
    -v "$cur_dir"/ruuvi-names.properties:/app/target/ruuvi-names.properties:ro \
    ruuvi-collector:"$docker_image_tag"
