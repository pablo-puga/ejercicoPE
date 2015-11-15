# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "puphpet/centos65-x64"

  config.vm.network "private_network", ip: "192.168.33.60"

  config.vm.hostname = "preEx"

  #Las variables son paths relativos desde la carpeta donde esta el fichero Vagrantfile
  config.vm.provision :puppet do |puppet|
        puppet.environment_path = "environments"
        puppet.environment      = "development"
        puppet.module_path      = "modules"
  end

end

