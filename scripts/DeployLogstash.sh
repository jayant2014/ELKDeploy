#!/bin/bash

. ../utils/MainUtils.sh

CONFIG=../config/logstash.cfg
VERSION=`getConfigs VERSION`

LOGSTASH_CONFIG=/etc/elasticsearch/elasticsearch.yml

isCentos=`cat /etc/os-release | grep -ic redhat`
isUbuntu=`cat /etc/os-release | grep -ic ubuntu`

if [ $isCentos -gt 0 ]
then
    cmd "rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch" "GPG check key added" "Adding GPG check key failed."
    cp -pf ../centrepos/logstash.repo .
    sed -i "s%version%$VERSION%g" logstash.repo
    cmd "cp -pf logstash.repo /etc/yum.repos.d/" "logstash.repo copied" "Copying elastic repo failed."
    echo -e "Installing logstash...."
    cmd "yum -y install logstash" "logstash installed successfully." "logstash installation failed."
    echo -e "Adding logstash as a service...."
    /sbin/chkconfig --add logstash
    /bin/systemctl daemon-reload
    /bin/systemctl enable logstash.service
elif [ $isCentos -gt 0 ]
then
    cmd "wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -" "GPG check key added" "Adding GPG check key failed."
    cmd "echo \"deb http://packages.elastic.co/logstash/$VERSION/debian stable main\" | tee -a /etc/apt/sources.list" "" ""
    cmd "apt-get -y update" "" "apt-get update failed."
    cmd "apt-get -y install logstash" "Logstash installed successfully." "Logstash installation failed"
    echo -e "Adding logstash as a service...."
    cmd "update-rc.d logstash defaults 92 10" "logstash added as a service." "Adding logstash as a service failed."
    echo -e "Starting logstash service...."
    cmd "service logstash start"
fi

# Securing node, no access to outside host

