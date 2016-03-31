#!/bin/bash

. ../utils/MainUtils.sh

CONFIG=../config/kibana.cfg
VERSION=`getConfigs VERSION`

ELASTIC_CONFIG=/etc/elasticsearch/elasticsearch.yml

isCentos=`cat /etc/os-release | grep -ic redhat`
isUbuntu=`cat /etc/os-release | grep -ic ubuntu`

if [ $isCentos -gt 0 ]
then
    cmd "rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch" "GPG check key added" "Adding GPG check key failed."
    cp -pf ../centrepos/kibana.repo .
    sed -i "s%version%$VERSION%g" kibana.repo
    cmd "cp -pf kibana.repo /etc/yum.repos.d/" "kibana.repo copied" "Copying elastic repo failed."
    echo -e "Installing kibana...."
    cmd "yum -y install kibana" "kibana installed successfully." "kibana installation failed."
    echo -e "Adding kibana as a service...."
    /sbin/chkconfig --add kibana
    /bin/systemctl daemon-reload
    /bin/systemctl enable kibana.service
elif [ $isCentos -gt 0 ]
then
    cmd "wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -" "GPG check key added" "Adding GPG check key failed."
    cmd "echo \"deb http://packages.elastic.co/kibana/$VERSION/debian stable main\" | tee -a /etc/apt/sources.list" "" ""
    cmd "apt-get -y update" "" "apt-get update failed."
    cmd "apt-get -y install kibana" "Logstash installed successfully." "Logstash installation failed"
    echo -e "Adding kibana as a service...."
    cmd "update-rc.d kibana defaults 93 10" "kibana added as a service." "Adding kibana as a service failed."
    echo -e "Starting kibana service...."
    cmd "service kibana start"
fi

# Securing node, no access to outside host

