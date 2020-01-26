# RuuviTags data collection on Raspberry PI

These tools provide means to collect measurement data from RuuviTags, store it
in InfluxDB and display the data through Grafana.

## Network structure between created docker containers

This section describes the network confiration used for communication between
the different docker containers. Helper scripts in this directory and start
scripts for each component are configured to setup and use this network
configuration.

The network configuration is designed to allow only the minimum that is required
for each component.

### RuuviCollector

RuuviCollector requires access to host network in order to be able to access
Bluetooth LE devices so that it's able to listen messages from RuuviTags.

Additionally RuuviCollector requires access to InfluxDb container in order to
write recorded data from RuuviTags to the database.

When a docker container is connected to host network, it can't be connected to
any other docker bridge network at the same time. Therefore, access
RuuviCollector needs access to InfluxDb from host network.

For these reasons, RuuviCollector has these connections:

- Connected to host network in order to access Bluetooth LE devices
- Writes to InfluxDb through 127.0.0.1:8086 published from InfluxDb Container

### InfluxDb

InfluxDb needs to be listening for write requests from RuuviCollector and read
requests from Grafana.

For those reasons, InfluxDb has these connections:

- `grafana-influxbd` docker bridge network to provide data for Grafana
- Binds port 8086 to 127.0.0.1:8086 on host machine allowing RuuviCollector to
  write data through that port. Technically this allows anyone from within the
  same machine to make requests to InfluxDb, but only RuuviCollector is
  configured to use that port.

### Grafana

Grafana needs to be able to read data from InfluxDb and it needs to be listening
on port 3000 of host machine in order for clients to access the Grafana Web UI.

For those reasons, Grafana has these connections:

- `grafana-influxdb` docker bridge network to read data from InfluxDb
- Binds port 3000 to *:3000 on host machine allowing anyone with access to host
  machine in the network to access Grafana Web UI.

## Initial setup

1. Install needed packages to host raspberry
    - `docker-ce`:
      <https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script>
2. Create docker networks
    - Run `./docker-network-setup.sh` script to create networks
3. Install InfluxDB
    - See [influxdb/README.md](influxdb/README.md) for instructions
4. Install RuuviCollector
    - See [ruuvi-collector/README.md](ruuvi-collector/README.md) for
      instructions
5. Install Grafana
    - See [grafana/README.md](grafana/README.md) for instructions

## Updates

New versions of all of these tools provide security fixes, bug fixes and new
features. Update all to newer versions every once in a while.

README files of each component contain update instructions.
