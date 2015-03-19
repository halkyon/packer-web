#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Setup apt repository for PHP
wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
echo 'deb http://packages.dotdeb.org squeeze all' > /etc/apt/sources.list.d/dotdeb.list
echo 'deb-src http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list.d/dotdeb.list

# Install software
apt-get update
apt-get -y install \
	apache2 libapache2-mod-php5 php5 php5-apc php5-common php5-cli \
	php5-tidy php5-ldap php5-mcrypt php5-curl php5-imagick \
	php5-gd php5-sqlite php5-mysql

echo 'apc.shm_size=128M' >> /etc/php5/conf.d/apc.ini
echo 'apc.stat=1' >> /etc/php5/conf.d/apc.ini
echo 'apc.mmap_file_mask=/tmp/apc.XXXXXX' >> /etc/php5/conf.d/apc.ini