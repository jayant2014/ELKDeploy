#!/bin/bash

. ../utils/MainUtils.sh

NODE=$1
CONFIG=../config/marvel.cfg
VERSION=`getConfigs VERSION`
ES_HOME=/usr/share/elasticsearch/
KIBANA_HOME=/opt/kibana

KIBANA_CONFIG=/opt/kibana/config/kibana.yml

echo -e "Installing marvel agent plugin on the node."
cd $ES_HOME
bin/plugin install license
bin/plugin install marvel-agent
service elasticsearch restart

echo -e "Installing the marvel app into kibana."
cd $KIBANA_HOME
bin/kibana plugin --install elasticsearch/marvel/latest
service kibana restart

