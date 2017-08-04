# Setup (Windows)

## Dependencies 

To get this going, you're going to need a few bits installed on your system.

### VirtualBox (Required)
VirtualBox is a system which lets you make VMs. You'll be handling the commands through Vagrant, but still need this running in 
the background.

https://www.virtualbox.org/wiki/Downloads

### Vagrant (Required)
Vagrant is a system which hooks into virtualbox (or VMWare if you're into that kinda thing). Which provisions the box and adds 
some commands to handle bringing the system up and down.

https://www.vagrantup.com/

### Cmder (Recommended)
Cmder is a terminal which has commonly used functions you'd find in a linux terminal, like grep, ssh, git, and find. This is not a 
requirement, but stops you from having to enter the IP address of the VM every time you try to access the system.

http://cmder.net/

## Setup

### Folder structure

You can place the files where you want, but I'd recommend C:\Users\$homedirectory. In here, you'll need to create a "Sites" directory. 
This is where your websites will live.

If you've installed Cmder, you'll be able to change into this directory, and type:

```bash
git clone https://github.com/amonger/centos-vagrant Vagrant
```

This will pull down the latest version of the repository, and place it in a directory called Vagrant.

### Websites

The system has been configured to read from the _domains.txt_ file, which will generate a NGINX config file, as well as a PHP-FPM 
config file, which will have its socket generated and applie to the nginx config.

This bit is a work in progress, as it would be nice to have a file which is read which allows configuration of local databases.

### Stuff thats included

* MariaDB (which by default uses XtraDB)
* PHP70
* NPM
* Node
* Ruby
* Cowsay
* VIM

### Installation
If all your dependencies are installed, change into the Vagrant directory, and type:

```bash
vagrant up
```
You might get an error about mounting directories. This is because the vm's virtualbox plugin is out of date. Run

```bash
vagrant plugin install vagrant-vbguest
```

Then

```bash
vagrant reload
```

On thing i need to fix is adding nginx to the vagrant group to fix binding issues. Until then you'll need to

```bash
useradd nginx
```

After it tells you that it cant find user nginx.

This will bring up the machine, download the VM, and provision the system.
You might see some errors, these are mainly going to be errors related to keysigning, which can be ignored.

When everything is finished, you should see a stegosaurus with a hat on, dispensing some wisdom.

### Post installation

You should now notice that the domains that you listed in the domains.txt file now are in your sites directory. You'll 
also note that your configuration files (nginx/fpm) are listed under the Vagrant/config directories. These config files 
will not be overwritten if they already exist (so feel free to make modifications).

The database is also backed up in 5 min intervals, which is imported on provisioning the system.

## New Domains
If you wish to add a new domain, update the domains.txt file and run
```bash
vagrant provision
```

This will rerun the execution script, and create your new directory.

## Navigating the VM
The VM is structured in a fairly standard way, with /var/www/vhosts mapped to your external Sites directory, /etc/nginx/conf.d 
mapped to Vagrant/conf/nginx and /etc/php-fpm.d mapped to Vagrant/php-fpm.

The root directory of your Vagrant folder is also in /Vagrant.

## Issues

Sometimes things go wrong. Heres how to fix it:

### Vagrant commands

#### Restart the machine
```bash
vagrant reload
```

#### Destory the machine

```bash
vagrant destroy
```

(You'll want to follow this up with a ```bash vagrant up ```

### Nginx and FPM related issues

You might get an error when reprovisioning your machine. You can log into the machine using:

```bash 
vagrant ssh  
```

and issuing the command 

```bash
chmod 777 /run/*.sock
```

You can check the state of your files by running  ```bash php-fpm -t ``` to check your fpm config files and ```bash 
nginx -t ``` to check your nginx config. You're able to make modifications within the Vagrant/config directory, however if you want to
make modifications to these files in the server, you can get to them via

```bash
/etc/nginx/conf.d
/etc/php-fpm.d
```

