#!/bin/bash

. ../utils/MainUtils.sh

NODE=$1
CONFIG=../config/marvel.cfg
VERSION=`getConfigs VERSION`
USER=`getConfigs USER`
ES_HOME=/usr/share/elasticsearch/
KIBANA_HOME=/opt/kibana

KIBANA_CONFIG=/opt/kibana/config/kibana.yml

echo -e "Installing shield on the node."
cd $ES_HOME
bin/plugin install license
bin/plugin install shield
bin/shield/esusers useradd $USER -r admin
service elasticsearch restart
