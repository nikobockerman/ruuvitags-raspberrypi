#!/bin/bash

set -ex

cur_dir=$(dirname "$(readlink -f "$0")")

rm -rf "$cur_dir"/backup/old
if [ -d "$cur_dir"/backup/latest ]; then
  mv "$cur_dir"/backup/{latest,old}
fi

sudo docker exec -it influxdb influxd backup -portable /backups/latest
sudo chown $(whoami) -R backup/latest
