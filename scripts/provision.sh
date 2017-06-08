#!/bin/bash

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum update -y
sudo yum install nginx php71w-* --skip-broken -y

sudo sh /vagrant/scripts/add-domain.sh inspirehousekeeping.com

sudo chmod -R 777 /var/log/php-fpm
sudo service php-fpm restart
sudo service php-fpm reload
sudo chown nginx:nginx /run/*.sock
sudo service php-fpm start
sudo service nginx start


