#!/bin/bash

# Start mosquitto before syslog-ng so the syslog-ng mqtt
# client has a broker to connect to.
pushd ${BASE_DIR}/target
mv etc/init.d/*mosquitto etc/init.d/S41mosquitto || true
mv etc/init.d/*syslog-ng etc/init.d/S51syslog-ng || true
