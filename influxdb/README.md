# InfluxDB

These instructions are for running InfluxDB docker container as database for
RuuviTags measurement data together with RuuviCollector and Grafana.

## Initial creation

1. Generate configuration: `./generate-config.sh`
2. Rename generated configuration file to `influxdb.conf`:
   `mv influxdb.conf{.default,}`
3. Modify generated configuration file `influxdb.conf`
    - My changes to the defaults:
        - `[data]` / `cache-max-memory-size` = `"512m"`
            - Limits the amount of memory influxdb will allocate to itself
        - `[data]` / `max-concurrent-compactions` = `2`
            - Use max two cores to perform compactions
        - `[monitor]` / `store-enabled` = `false`
            - Disable internal monitoring. This causes a lot of performance
              issues on Raspberry when enabled:
              <https://github.com/influxdata/influxdb/issues/9475>
4. Create directory for backup: `mkdir backup`
5. Start container: `./start-influxdb.sh`
6. Create database for ruuvi-collector
    1. Connect to influxdb with influx client:
       `sudo docker run --rm --link=influxdb -it influxdb:1.7 influx -host influxdb`
    2. Execute the following command to create the needed ruuvi database with
       one year retention policy:
       `CREATE DATABASE "ruuvi" WITH DURATION 52w NAME "ruuvi_collector_policy"`

## Update influxdb container

1. Pull new version `./update-image.sh`
2. Backup database: `./backup.sh`
    - Deletes previous old backup from `./backup/old` if exists
    - Moves existing latest backup from `./backup/latest` to `./backup/old`
    - Creates new backup to `./backup/latest`
3. Stop old container `sudo docker container stop influxdb`
4. Rename old container for backup: `sudo docker container rename influxdb{,-old}`
5. Start new version: `./start-influxdb.sh`
6. Restore database: `./restore-from-backup.sh`

7. Verify that restored data is visible in Grafana
8. Verify RuuviCollector is able to store new data

9. Remove old container: `sudo docker container rm influxdb-old`
10. Remove unused images: `sudo docker image prune`
11. Optionally remove older backup to save disk space `rm -rf ./backup/old`
