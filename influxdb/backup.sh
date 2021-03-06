#!/bin/bash

set -ex

cur_dir=$(dirname "$(readlink -f "$0")")

rm -rf "$cur_dir"/backup/old
if [ -d "$cur_dir"/backup/latest ]; then
  mv "$cur_dir"/backup/{latest,old}
fi

sudo docker exec influxdb influxd backup -portable /backup/latest
sudo chown $(whoami) -R "$cur_dir"/backup/latest
