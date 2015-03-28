#!/bin/bash

COUNT=0

for path in ./builds/*; do
	let COUNT=COUNT+1
	base="${path##*/}"
	cd $path

	if [ -d ./.vagrant ]; then
		vagrant destroy --force
		vagrant box --force remove $base
		rm -rf .vagrant
		rm ./Vagrantfile
	fi

	vagrant box add --force $base vagrant.box

	cat << EOF > ./Vagrantfile
Vagrant.configure(2) do |config|
	config.vm.box = "$base"
	config.vm.network "forwarded_port", guest: 80, host: 800$COUNT
	config.vm.provider "virtualbox" do |vb|
		vb.customize ["modifyvm", :id, "--memory", "2048"]
		vb.customize ["modifyvm", :id, "--cpus", "2"]
		vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end
end
EOF

	vagrant up

	testURL=http://localhost/page-top-level-1/page-second-level-1-1/page-third-level-1-1-1/page-fourth-level-1-1-1-1/

	vagrant ssh -c "siege -c 1 -b -t 20S $testURL \
		&& siege -c 1 -b -t 20S $testURL \
		&& siege -c 1 -b -t 20S $testURL \
		&& siege -c 5 -b -t 20S $testURL \
		&& siege -c 5 -b -t 20S $testURL \
		&& siege -c 5 -b -t 20S $testURL \
		&& siege -c 10 -b -t 20S $testURL \
		&& siege -c 10 -b -t 20S $testURL \
		&& siege -c 10 -b -t 20S $testURL \
		&& siege -c 20 -b -t 20S $testURL \
		&& siege -c 20 -b -t 20S $testURL \
		&& siege -c 20 -b -t 20S $testURL \
		&& siege -c 40 -b -t 20S $testURL \
		&& siege -c 40 -b -t 20S $testURL \
		&& siege -c 40 -b -t 20S $testURL \
		&& siege -c 60 -b -t 20S $testURL \
		&& siege -c 60 -b -t 20S $testURL \
		&& siege -c 60 -b -t 20S $testURL \
		&& siege -c 80 -b -t 20S $testURL \
		&& siege -c 80 -b -t 20S $testURL \
		&& siege -c 80 -b -t 20S $testURL \
		&& siege -c 100 -b -t 20S $testURL \
		&& siege -c 100 -b -t 20S $testURL \
		&& siege -c 100 -b -t 20S $testURL"

	if [ ! -d ../../test-results ]; then
		mkdir ../../test-results
	fi

	vagrant ssh -c 'cat ~/siege.csv' > ../../test-results/$base-test-$(date -d "today" +"%Y%m%d%H%M").csv

	vagrant destroy --force
	vagrant box --force remove $base
	rm -rf .vagrant
	rm ./Vagrantfile

	cd ../..
done
