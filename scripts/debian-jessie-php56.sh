#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Install software
apt-get update
apt-get -y install \
	apache2 libapache2-mod-php5 php5 php5-apcu php5-common php5-cli \
	php5-tidy php5-ldap php5-mcrypt php5-curl php5-imagick \
	php5-gd php5-sqlite php5-mysqlnd

echo 'opcache.revalidate_freq=0' >> /etc/php5/mods-available/opcache.ini
echo 'opcache.max_accelerated_files=8000' >> /etc/php5/mods-available/opcache.ini
echo 'opcache.memory_consumption=128' >> /etc/php5/mods-available/opcache.ini
echo 'opcache.interned_strings_buffer=16' >> /etc/php5/mods-available/opcache.ini
echo 'opcache.fast_shutdown=1' >> /etc/php5/mods-available/opcache.ini