#!/bin/bash -ex
export DEBIAN_FRONTEND=noninteractive

# Setup apt repository for HHVM
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
echo 'deb http://dl.hhvm.com/debian wheezy-lts-3.6 main' > /etc/apt/sources.list.d/hhvm.list

# Install software
apt-get update
apt-get -y install nginx hhvm

# Replace the php executable with HHVM for CLI scripts
/usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

# Start on boot (it won't by default)
update-rc.d hhvm defaults
