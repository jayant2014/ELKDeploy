#!/bin/bash

# This script is for deploying elasticsearch on your host as a service
. ../utils/MainUtils.sh

CONFIG=../config/elastic.cfg
VERSION=`getConfigs VERSION`
CLUSTER=`getConfigs CLUSTER`
NODE=`getConfigs NODE`

ELASTIC_CONFIG=/etc/elasticsearch/elasticsearch.yml

isCentos=`cat /etc/os-release | grep -ic redhat`
isUbuntu=`cat /etc/os-release | grep -ic ubuntu`

if [ $isCentos -gt 0 ]
then
    cmd "rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch" "GPG check key added" "Adding GPG check key failed."
    cp -pf ../centrepos/elastic.repo .
    sed -i "s%version%$VERSION%g" elastic.repo
    cmd "cp -pf elastic.repo /etc/yum.repos.d/" "elastic.repo copied" "Copying elastic repo failed."
    echo -e "Installing elasticsearch...."
    cmd "yum -y install elasticsearch" "elasticsearch installed successfully." "elasticsearch installation failed."
    echo -e "Adding elasticsearch as a service...."
    /sbin/chkconfig --add elasticsearch
    /bin/systemctl daemon-reload
    /bin/systemctl enable elasticsearch.service
elif [ $isCentos -gt 0 ]
then
    cmd "wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -" "GPG check key added" "Adding GPG check key failed."
    cmd "echo 'deb http://packages.elastic.co/elasticsearch/2.x/debian stable main' | sudo tee -a /etc/apt/sources.list" "" ""
    cmd "apt-get -y update" "" "apt-get update failed."
    cmd "apt-get -y install elasticsearch" "Elasticsearch installed successfully." "Elasticsearch installation failed"
    echo -e "Adding elasticsearch as a service...."
    cmd "update-rc.d elasticsearch defaults 91 10" "elasticsearch added as a service." "Adding elsaticsearch as a service failed."
    echo -e "Starting elasticsearch service...."
    cmd "service elasticsearch start"
fi

# Securing node, no access to outside host

