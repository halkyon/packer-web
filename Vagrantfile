# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	config.vm.box = "packer_virtualbox-iso-debian_virtualbox.box"
	config.ssh.username = "vagrant"
	config.ssh.password = "vagrant"
	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "private_network", ip: "10.0.1.2"
	config.vm.provider "virtualbox" do |vb|
		vb.customize ["modifyvm", :id, "--memory", "1024"]
		vb.customize ["modifyvm", :id, "--cpus", "2"]
	end
end
