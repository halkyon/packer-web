#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Allow vagrant user to run sudo commands
echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
echo "Defaults:vagrant !requiretty" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Allow vagrant user to get in without a password using a temporary SSH key
mkdir -p /home/vagrant/.ssh
wget --no-check-certificate \
        https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
        -O /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

# Disable reverse lookup in SSH to speed things up
echo -e "Host *\n    UseDNS no" >> /etc/ssh/ssh_config

# Setup apt repository for wheezy backports
echo 'deb http://http.debian.net/debian wheezy-backports main' > /etc/apt/sources.list.d/wheezy-backports.list

# Update apt sources
apt-get update
apt-get -y dist-upgrade

# Install software
apt-get -y install vim telnet less lynx wget ntp htop curl rsync siege

# Install backports software
apt-get -y -t wheezy-backports install git

# Install composer
wget -O /usr/local/bin/composer https://getcomposer.org/composer.phar
chmod +x /usr/local/bin/composer
