#!/bin/bash -ex

# allow vagrant user to run sudo commands
echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
echo "Defaults:vagrant !requiretty" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# allow vagrant user to get in without a password using a temporary SSH key
mkdir -p /home/vagrant/.ssh
wget --no-check-certificate \
	https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
	-O /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

# disable reverse lookup in SSH to speed things up
echo "UseDNS no" >> /etc/ssh/sshd_config
