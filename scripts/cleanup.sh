#!/bin/bash -ex

# remove development packages
apt-get -y purge linux-headers-$(uname -r) build-essential dkms
apt-get -y autoremove
apt-get -y clean
apt-get autoclean

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

# zero-fill the boot partition to aid in VM compression
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count || echo "dd exit code $? is suppressed";
rm -f /boot/whitespace;

set +e
swapuuid="`/sbin/blkid -o value -l -s UUID -t TYPE=swap`";
case "$?" in
	2|0) ;;
	*) exit 1 ;;
esac
set -e

# zero-fill the swap partition to aid in VM compression
if [ "x${swapuuid}" != "x" ]; then
	# Whiteout the swap partition to reduce box size
	# Swap is disabled till reboot
	swappart="`readlink -f /dev/disk/by-uuid/$swapuuid`";
	/sbin/swapoff "$swappart";
	dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed";
	/sbin/mkswap -U "$swapuuid" "$swappart";
fi

dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# block until the empty file has been deleted
sync
