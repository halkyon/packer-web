#!/bin/bash -ex

# The root credentials for MariaDB installer
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password root'

# Install software
apt-get -y install mariadb-server mariadb-client
