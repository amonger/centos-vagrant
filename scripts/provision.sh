#!/bin/bash

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum update -y
sudo yum install vim nano nginx mariadb-server php71w-* --skip-broken -y

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/sbin --filename=composer
php -r "unlink('composer-setup.php');"

while read domain; do
    sudo sh /vagrant/scripts/add-domain.sh "${domain}"
done </vagrant/domains.txt

sudo chmod -R 777 /var/log/php-fpm
sudo service php-fpm restart
sudo service php-fpm reload
sudo chown nginx:nginx /run/*.sock
sudo service php-fpm start
sudo service nginx start
sudo service mariadb start

