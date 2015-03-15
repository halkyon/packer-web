#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Allow vagrant user to run sudo commands
echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
echo "Defaults:vagrant !requiretty" >> /etc/sudoers.d/vagrant

# Disable reverse lookup in SSH to speed things up
echo "Host *\n    UseDNS no" >> /etc/ssh/ssh_config

# Setup apt repository for squeeze backports
echo 'deb http://http.debian.net/debian squeeze-backports main' > /etc/apt/sources.list.d/squeeze-backports.list

# Update apt sources
apt-get update
apt-get -y dist-upgrade

# Install software
apt-get -y install vim telnet less lynx wget ntp htop curl rsync siege

# Install backports software
apt-get -y -t squeeze-backports install git

# Install composer
wget -O /usr/local/bin/composer https://getcomposer.org/composer.phar
chmod +x /usr/local/bin/composer
