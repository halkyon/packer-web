#!/bin/bash -x

if [ ! -e /home/vagrant/.vbox_version ]; then
	exit 0
fi

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=/home/vagrant/VBoxGuestAdditions.iso

apt-get update
apt-get -y dist-upgrade
apt-get -y install linux-headers-$(uname -r) build-essential dkms

if [ -f /etc/init.d/virtualbox-ose-guest-utils ]; then
	/etc/init.d/virtualbox-ose-guest-utils stop
	rmmod vboxguest
	apt-get -y purge virtualbox-ose-guest-x11
	apt-get -y autoremove
	apt-get -y purge virtualbox-ose-guest-utils
	apt-get -y purge virtualbox-ose-guest-dkms
elif [ -f /etc/init.d/virtualbox-guest-utils ]; then
	/etc/init.d/virtualbox-guest-utils stop
	apt-get -y purge virtualbox-guest-x11
	apt-get -y autoremove
	apt-get -y purge virtualbox-guest-utils
	apt-get -y purge virtualbox-guest-dkms
fi

if [ ! -f $VBOX_ISO ]; then
	wget -q http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso -O $VBOX_ISO
fi

mount -o loop $VBOX_ISO /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm $VBOX_ISO