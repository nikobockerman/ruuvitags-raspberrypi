#!/bin/bash

set -ex

cur_dir=$(dirname "$(readlink -f "$0")")

sudo docker run \
    -d \
    -p 127.0.0.1:8086:8086 \
    --name influxdb \
    --restart unless-stopped \
    -v influxdb-storage-new:/var/lib/influxdb \
    -v "$cur_dir"/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
    influxdb:1.7 -config /etc/influxdb/influxdb.conf
