#!/bin/bash

ct_monitor_slave=$(bash get-env.sh "containers_monitor_slave")
ct_monitor_appname=$(bash get-env.sh "containers_monitor_appname")
ct_monitor_containers=$(bash get-env.sh "containers_monitor_containers")
ct_monitor_timeout=$(bash get-env.sh "containers_monitor_timeout")
ct_monitor_sleep_time=$(bash get-env.sh "containers_monitor_sleep_time")

echo "containers_monitor_slave: $ct_monitor_slave"
echo "containers_monitor_appname: $ct_monitor_appname"
echo "containers_monitor_containers: $ct_monitor_containers"
echo "containers_monitor_timeout: $ct_monitor_timeout"
echo "containers_monitor_sleep_time: $ct_monitor_sleep_time"
