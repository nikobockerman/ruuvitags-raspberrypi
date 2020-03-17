#!/bin/bash

set -ex

sudo docker exec -it influxdb influxd restore -portable /backup/latest
