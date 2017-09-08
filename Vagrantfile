# -*- mode: ruby -*-
# vi: set ft=ruby :
#
if not Vagrant.has_plugin?('vagrant-vbguest')
  abort <<-EOM

vagrant plugin vagrant-vbguest is required.
https://github.com/dotless-de/vagrant-vbguest
To install the plugin, please run, 'vagrant plugin install vagrant-vbguest'.

  EOM
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.define "test", primary: true, autostart: true do |server|
    server.vm.box = 'centos/7'
    server.vm.hostname = 'test.example.com'
    server.vm.network :private_network, ip: '192.168.99.10'
    server.vm.provision :shell, :path => "vagrant/provision.sh"
    server.vm.provision :shell, :inline => "echo '/etc/hosts before puppet run'; cat /etc/hosts"
    server.vm.provision :shell, :inline => "puppet apply /vagrant/examples/init.pp"
    server.vm.provision :shell, :inline => "echo '/etc/hosts after puppet run'; cat /etc/hosts"
    server.vm.provision :shell, :path => "vagrant/checks.sh"
  end
end
