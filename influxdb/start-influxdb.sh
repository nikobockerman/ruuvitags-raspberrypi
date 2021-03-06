#!/bin/bash

set -ex

cur_dir=$(dirname "$(readlink -f "$0")")

sudo docker run \
    -d \
    -p 127.0.0.1:8086:8086 \
    --network grafana-influxdb \
    --name influxdb \
    --restart unless-stopped \
    -v "$cur_dir"/backup:/backup \
    -v "$cur_dir"/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
    influxdb:1.7 -config /etc/influxdb/influxdb.conf
