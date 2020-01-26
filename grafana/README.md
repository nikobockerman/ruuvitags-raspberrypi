# Grafana

These scripts can be used to automate grafana docker container installation and
upgrade. These scripts setup grafana so that grafana is listening on port `3000`
on all host interfaces for HTTP connections from web browsers.

Grafana is started with such configuration that anonymous view access is allowed
to organization named `Koti`. This organization needs to be matched in
configuration setup through Grafana web interface.

## Initial installation

1. Create storage for grafana by running: `./create-storage.sh`
2. Perform steps 1 and 4 from Updating grafana container to get grafana
   installed and running.
3. Perform initial setup with web browser by connecting to raspberry pi port
   3000
    - Port number is specified in `start-grafana.sh`
    - Perform initial setup
        - Create admin user account for modifying settings and views
        - Set organization name to `Koti`
            - Default organization can be renamed under `Server Admin`/`Orgs`
        - Configure InfluxDb as data source
            - In `Configuration`/`Data Sources` add new data source (unless done
              through initial wizard)
            - My InfluxDb data source configuration (differences to defaults)
                - `Name`: `Ruuvi`
                - `HTTP` / `Url`: `http://influxdb:8086`
                    - Grafana and InfluxDb are under same `grafana-influxdb`
                      docker bridge network. InfluxDb container can be accessed
                      with the container name as host address.
                - `Auth` / `Skip TLS Verify`: `Checked`
                - `InfluxDB Details` / `Database`: `ruuvi`
                    - This should match the database name that has been created
                      to InfluxDB
4. Create dashboards to your liking!

## Updating grafana container

1. Pull new version `./update-image.sh`
2. Stop old container `sudo docker container stop grafana`
3. Rename old container for backup:
   `sudo docker container rename grafana{,-old}`
4. Start new version: `./start-grafana.sh`

5. Verify new version works with browser

6. Remove old container: `sudo docker container rm grafana-old`
7. Remove unused images: `sudo docker image prune`
