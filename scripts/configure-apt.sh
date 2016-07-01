#!/bin/bash -ex
cat << CONF > /etc/apt/sources.list.d/backports.list
deb http://httpredir.debian.org/debian jessie-backports main
CONF

apt-get update
apt-get -y dist-upgrade
apt-get -y install apt-transport-https lsb-release
