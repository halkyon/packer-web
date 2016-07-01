#!/bin/bash -x
umount /vagrant

# remove development packages
apt-get -y purge linux-headers-$(uname -r) build-essential dkms
apt-get -y autoremove
apt-get autoclean

# zero out free disk space to aid in VM compression
# this keeps filling right to the end of the disk
# so it should error with "no space left on device" when completed
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# remove apt caches and documentation files
find /var/lib/apt -type f | xargs rm -f
find /var/lib/doc -type f | xargs rm -f

# empty out log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# remove dhcp leases
rm /var/lib/dhcp/*

# remove virtualbox source files
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

# remove linux headers
rm -rf /usr/src/linux-headers*

# remove bash history
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

# zero-fill the root partition
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;

# zero-fill the boot partition
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;
