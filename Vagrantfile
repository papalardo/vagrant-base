# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "ubuntu/trusty64"
    #config.vm.box = "precise64"
    #config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    
    # Mount shared folder using NFS
    #config.vm.synced_folder ".", "/vagrant", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp,noatime']
    config.vm.synced_folder "www", "/var/www", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp,actimeo=2']

    # Do some network configuration
    config.vm.network "forwarded_port", host: 80, guest: 80, auto_correct: true
    config.vm.network "forwarded_port", host: 443, guest: 443, auto_correct: true
    config.vm.network "forwarded_port", host: 3306, guest: 3306, auto_correct: true
    config.vm.network "private_network", ip: "10.0.0.5"
    config.ssh.forward_agent = true

    # Assign a quarter of host memory and all available CPU's to VM
    # Depending on host OS this has to be done differently.
    config.vm.provider "virtualbox" do |v|    
        v.name = "wavez-vagrant"
        v.customize ["modifyvm", :id, "--memory", "4096", "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    end

    config.vm.provision :shell, :path => "provision.sh"

end