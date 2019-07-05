#!/bin/bash

set -xe

sudo docker run \
    -d \
    -p 3000:3000 \
    --name grafana \
    --restart unless-stopped \
    -e "GF_AUTH_ANONYMOUS_ENABLED=true" \
    -e "GF_AUTH_ANONYMOUS_ORG_NAME=Koti" \
    -v grafana-storage:/var/lib/grafana \
    grafana/grafana
