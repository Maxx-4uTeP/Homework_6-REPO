# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

config.vm.define "server" do |server|
  config.vm.box = 'centos/7'
  server.vm.host_name = 'server'
  server.vm.network :private_network, ip: "10.0.0.41"

  server.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end


  server.vm.provision "file", source: "files/nginx.spec", destination: "$HOME/nginx.spec" 
  server.vm.provision "shell", path: "files/server.sh"
  server.vm.provision "shell", path: "files/createrepo.sh"

end



end
