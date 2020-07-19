#!/bin/bash

set -ex

sudo docker run \
     --rm \
     -it \
     --link=influxdb \
     --network grafana-influxdb \
     influxdb:1.7 \
     influx -host influxdb
