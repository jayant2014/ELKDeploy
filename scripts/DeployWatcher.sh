#!/bin/bash

. ../utils/MainUtils.sh

NODE=$1
CONFIG=../config/watcher.cfg
VERSION=`getConfigs VERSION`
USER=`getConfigs USER`
ES_HOME=/usr/share/elasticsearch/
KIBANA_HOME=/opt/kibana

KIBANA_CONFIG=/opt/kibana/config/kibana.yml

echo -e "Installing watcher on the node."
cd $ES_HOME
bin/plugin install license
bin/plugin install watcher
service elasticsearch restart
