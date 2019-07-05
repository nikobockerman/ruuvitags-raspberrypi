# RuuviTags data collection on Raspberry PI

These tools provide means to collect measurement data from RuuviTags, store it in
InfluxDB and display the data through Grafana.


## Network structure between created docker containers

These network configurations are configured in the start scripts for each component.
This section describes how they are linked together.

- RuuviCollector is using network of host directly. This is required as it needs to
  be able to access Bluetooth LE devices for listening RuuviTags.

- InfluxDB is configured to provide one port for writing data from host machine. This
  port can only be accessed from within host machine, not from the network where host
  machine is. This is needed so that RuuviCollector can write data to InfluxDB from as
  it is using host network directly and is not inside the separate network created by
  docker. The same data port is also accessible from other docker containers running in
  the same LAN created by docker.

- Grafana has access to InfluxDB through the same LAN created by docker where they are
  running.
  Grafana opens one port on the host machine to be available for connections on any
  network interface on the host machine. This allows web browsers to access Grafana Web UI.


## Initial setup

1. Install needed packages to host raspberry
  - `docker-ce`: https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script
  
2. Install InfluxDB
  - See [influxdb/README.md](influxdb/README.md) for instructions
3. Install RuuviCollector
  - See [ruuvi-collector/README.md](ruuvi-collector/README.md) for instructions
4. Install Grafana
  - See [grafana/README.md](grafana/README.md) for instructions


## Updates

New versions of all of these tools provide security fixes, bug fixes and new features.
Update all to newer versions every once in a while.

README files of each component contain update instructions.
