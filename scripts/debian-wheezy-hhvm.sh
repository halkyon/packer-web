#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Setup apt repository for HHVM
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
echo 'deb http://dl.hhvm.com/debian wheezy main' > /etc/apt/sources.list.d/hhvm.list

# Install software
apt-get update
apt-get -y -t wheezy-backports install nginx
apt-get -y install hhvm
