# InfluxDB

These instructions are for running InfluxDB docker container as database for
RuuviTags measurement data together with RuuviCollector and Grafana.


## Initial creation

1. Create storage: `./create-storage.sh`
2. Generate configuration: `./generate-config.sh`
3. Rename generated configuration file to `influxdb.conf`:
   `mv influxdb.conf{.default,}`
4. Modify generated configuration file `influxdb.conf`
  - My changes to the defaults:
    - `[data]` / `cache-max-memory-size` = `"512m"`
      - Limits the amount of memory influxdb will allocate to itself
    - `[data]` / `max-concurrent-compactions` = `2`
      - Use max two cores to perform compactions
    - `[monitor]` / `store-enabled` = `false`
      - Disable internal monitoring. This causes a lot of performance issues on
        Raspberry when enabled:
        https://github.com/influxdata/influxdb/issues/9475
5. Start container: `./start-influxdb.sh`
6. Create database for ruuvi-collector
  1. Connect to influxdb with influx client:
    `sudo docker run --rm --link=influxdb -it influxdb:1.7 influx -host influxdb`
  2. Execute the following command to create the needed ruuvi database with one year retention policy:
    `CREATE DATABASE "ruuvi" WITH DURATION 52w NAME "ruuvi_collector_policy"`


## Update influxdb container

1. Pull new version `./update-image.sh`
2. Stop old container `sudo docker container stop influxdb`
3. Rename old container for backup: `sudo docker container rename influxdb{,-old}`
4. Start new version: `./start-influxdb.sh`

5. Verify new version works by checking that grafana gets new data from ruuvi tags

6. Remove old container: `sudo docker container rm influxdb-old`
7. Remove unused images: `sudo docker image prune`
