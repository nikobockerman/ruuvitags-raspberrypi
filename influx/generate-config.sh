#!/bin/bash

set -xe

sudo docker run --rm influxdb:1.7 influxd config > influxdb.conf.default

echo "Default configuration generated to influxdb.conf.default. Update influxdb.conf as needed and restart container with new configuration file."

