# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.network "private_network", ip: "192.168.50.100"
  config.vm.box = "boxcutter/centos72"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.synced_folder "../Sites", "/var/www/vhosts"
  config.vm.synced_folder "./config/nginx", "/etc/nginx/conf.d"
  config.vm.synced_folder "./config/php-fpm", "/etc/php-fpm.d"
  config.vm.synced_folder "./config/databases", "/databases"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end
  config.vm.provision "shell", path: "scripts/provision.sh"
end
