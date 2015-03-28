#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Setup apt repository for MariaDB
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
echo 'deb http://mirror.aarnet.edu.au/pub/MariaDB/repo/10.0/debian wheezy main' > /etc/apt/sources.list.d/mariadb.list
echo 'deb-src http://mirror.aarnet.edu.au/pub/MariaDB/repo/10.0/debian wheezy main' >> /etc/apt/sources.list.d/mariadb.list

# The root credentials for MariaDB installer
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password root'

# Install software
apt-get update
apt-get -y install mariadb-server mariadb-client