## Initial creation

1. Clone git repository to repo directory:
  `git clone https://github.com/nikobockerman/RuuviCollector.git repo`
2. Checkout repo to a desired version:
  - See ## Select ruuvi-collector version
3. Build docker image: `./create-image.sh`
4. Create configuration:
  - Copy the example one: `cp repo/ruuvi-collector.properties.example ruuvi-collector.example`
  - Modify it according to desired setup
    - My modifications:
      - Influxdb related settings should match what was set when database was created:
        storage.method=influxdb
        influxUrl=http://127.0.0.1:8086
        influxDatabase=ruuvi
        influxMeasurement=ruuvi_measurements
        influxRetentionPolicy=ruuvi_collector_policy
      - Set desired interval for writing data to Influxdb (one entry per minute):
        measurementUpdateLimit=59900
      - Only use ruuvi tags that are listed in ruuvi-names.properties
        filter.mode=named
      - Blacklist information that I don't use in Grafana:
        storage.values=blacklist
        storage.values.list=accelerationX,accelerationY,accelerationZ,accelerationTotal,accelerationAngleFromX,accelerationAngleFromY,accelerationAngleFromZ,movementCounter

5. Create friendly names for tags that will be seen in Grafana:
  - Copy the example file: `cp repo/ruuvi-names.properties.example ruuvi-names.example`
  - List ruuvi tags MAC addresses and give them desired names
6. Start ruuvi-collector: `./start-collector.sh`

## Update ruuvi-collector container

1. Pull new base image: `./update-base-image.sh`
2. Update git repo to version you want to use
  - See ## Select ruuvi-collector version
3. Build new docker image: `./create-image.sh`
4. Stop old container `sudo docker container stop ruuvi-collector`
5. Rename old container for backup: `sudo docker container rename ruuvi-collector{,-old}`
6. Start new version: `./start-collector.sh`

7. Verify new version works by checking that grafana gets new data from ruuvi tags

8. Remove old container: `sudo docker container rm ruuvi-collector-old`
9. Remove unused images: `sudo docker image prune`
  - This can also be done only once after all containers are updated


## Select ruuvi-collector version

1. Enter repo directory: `cd repo`
2. Fetch repository information: `git fetch --all --prune`
3. List available branches: `git branch --all -vv`
4. Choose desired version branch from those that start with `remotes/origin/`
  - If same as previously
    - Update to newest version of that branch (make sure you don't have any local changes):
      `git reset --hard origin/version-0.2.5`
  - If new version branch
    - Checkout the new branch: `git checkout version-0.2.5`
5. Leave repo directory: `cd ..`


## Change configuration files
To take modified configuration files into use, ruuvi-collector docker image needs to be restarted:
`sudo docker container restart ruuvi-collector`


## Repo maintenance
1. If upstream has new version released
  - Create new version branch by copying and rebasing previous one
  - Remove unnecessary commits from the previous version branch
2. Update dependency versions in pom.xml
3. Push new branch / new commits to origin

