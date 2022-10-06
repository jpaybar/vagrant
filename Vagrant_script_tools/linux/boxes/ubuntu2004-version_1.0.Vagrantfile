# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  ### General setup ###
  config.vm.box = "ubuntu2004"
  config.vm.box_version = "1.0"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.box_check_update = false

  ### SSH setup ###
  config.ssh.username = "vagrant"
  #config.ssh.password = "vagrant"
  #=== In case you create your own keypair instead of Vagrant's insecure keypairs ===#
  #config.ssh.private_key_path = File.join(File.expand_path(File.dirname(__FILE__)), "vagrant.id_rsa")

end
