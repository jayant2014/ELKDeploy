#!/bin/bash

. ../utils/MainUtils.sh

NODE=$1
CONFIG=../config/graph.cfg
VERSION=`getConfigs VERSION`
USER=`getConfigs USER`
ES_HOME=/usr/share/elasticsearch/
KIBANA_HOME=/opt/kibana

KIBANA_CONFIG=/opt/kibana/config/kibana.yml

echo -e "Installing graph on the node."
cd $ES_HOME
bin/plugin install license
bin/plugin install graph
service elasticsearch restart

echo -e "Installing graph on kibana."
cd $KIBANA_HOME
bin/kibana plugin --install elasticsearch/graph/latest
service kibana restart
