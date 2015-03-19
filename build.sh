#!/bin/bash -ex

packer build build.json

for path in ./builds/*; do
	base="${path##*/}"
	cd $path

	if [[ -n $(vagrant status | grep running) ]]; then
		vagrant destroy --force
		vagrant box remove $base
	fi

	vagrant box add --force $base vagrant.box

	cat << EOF > ./Vagrantfile
Vagrant.configure(2) do |config|
	config.vm.box = "$base"
	config.vm.provider "virtualbox" do |vb|
		vb.customize ["modifyvm", :id, "--memory", "2048"]
		vb.customize ["modifyvm", :id, "--cpus", "2"]
		vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end
end
EOF

	vagrant up

	vagrant ssh -c 'siege -c 1 -b -t 20S http://localhost/ \
		&& siege -c 1 -b -t 20S http://localhost/ \
		&& siege -c 1 -b -t 20S http://localhost/ \
		&& siege -c 5 -b -t 20S http://localhost/ \
		&& siege -c 5 -b -t 20S http://localhost/ \
		&& siege -c 5 -b -t 20S http://localhost/ \
		&& siege -c 10 -b -t 20S http://localhost/ \
		&& siege -c 10 -b -t 20S http://localhost/ \
		&& siege -c 10 -b -t 20S http://localhost/ \
		&& siege -c 20 -b -t 20S http://localhost/ \
		&& siege -c 20 -b -t 20S http://localhost/ \
		&& siege -c 20 -b -t 20S http://localhost/ \
		&& siege -c 40 -b -t 20S http://localhost/ \
		&& siege -c 40 -b -t 20S http://localhost/ \
		&& siege -c 40 -b -t 20S http://localhost/ \
		&& siege -c 60 -b -t 20S http://localhost/ \
		&& siege -c 60 -b -t 20S http://localhost/ \
		&& siege -c 60 -b -t 20S http://localhost/ \
		&& siege -c 80 -b -t 20S http://localhost/ \
		&& siege -c 80 -b -t 20S http://localhost/ \
		&& siege -c 80 -b -t 20S http://localhost/ \
		&& siege -c 100 -b -t 20S http://localhost/ \
		&& siege -c 100 -b -t 20S http://localhost/ \
		&& siege -c 100 -b -t 20S http://localhost/'

	if [ ! -d ../../test-results ]; then
		mkdir ../../test-results
	fi

	vagrant ssh -c 'cat ~/siege.csv' > ../../test-results/$base-test-$(date -d "today" +"%Y%m%d%H%M").csv

	vagrant destroy --force
	vagrant box remove $base
	cd ../..
done
