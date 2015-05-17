#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Create a tmpfs for /tmp
echo 'tmpfs /tmp tmpfs mode=1777,nosuid,nodev,size=1G 0 0' >> /etc/fstab
mount /tmp

# Set the apt-cacher client configuration
#echo 'Acquire::http::Proxy "http://192.168.1.9:3142";' > /etc/apt/apt.conf.d/01proxy

# Update apt sources
apt-get update
apt-get -y dist-upgrade

# Install software
apt-get -y install vim telnet less lynx wget ntp htop curl rsync siege

# Install composer
wget -O /usr/local/bin/composer https://getcomposer.org/composer.phar
chmod +x /usr/local/bin/composer

# Configure siege
echo -e "cache=false\nlogfile=/home/vagrant/siege.csv\ncsv=true\nlogging=true\nverbose=false\n" > /home/vagrant/.siegerc
