# -*- mode: ruby -*-
# vi: set ft=ruby :

POPIT_VAGRANT_PORT = ENV['POPIT_VAGRANT_PORT'] || 3000
POPIT_VAGRANT_MEMORY = ENV['POPIT_VAGRANT_MEMORY'] || 1024
POPIT_VAGRANT_EXTRAS = ENV['POPIT_VAGRANT_EXTRAS']

Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, guest: 3000, host: POPIT_VAGRANT_PORT

  config.vm.provider :virtualbox do |v|
    # assign memory and CPU as needed
    v.customize ["modifyvm", :id, "--memory", POPIT_VAGRANT_MEMORY]
  end

  # Provision using the shell provisioner
  config.vm.provision :shell, :path => "config/provision.sh"
end

# If you want to add additional configuration options then create a file
# containing another 'Vagrant.configure' block and point the
# POPIT_VAGRANT_EXTRAS environment variable to it.
if POPIT_VAGRANT_EXTRAS
  require POPIT_VAGRANT_EXTRAS
end
