#!/bin/bash

echo "Adding Repositories"
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -

echo "Installing Dependencies"
sudo yum update -y
sudo yum install git fortune-mod cowsay vim nano ruby nodejs nginx mariadb-server php71w-* --skip-broken -y
sudo yum install gcc kernel-devel kernel-headers dkms make bzip2 perl -y

KERN_DIR=/usr/src/kernels/`uname -r`
export KERN_DIR

echo "Articulating Splines"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/sbin --filename=composer
php -r "unlink('composer-setup.php');"

echo "Configuring Domains"
while read domain; do
	echo "Adding domain ${domain}"
sudo sh /vagrant/scripts/add-domain.sh "${domain}"
done </vagrant/domains.txt

echo "Updating Permissions"
sudo chmod -R 777 /var/log/php-fpm
sudo service php-fpm restart
sudo service php-fpm reload
sudo chown nginx:nginx /run/*.sock

echo "Starting Services"
sudo service php-fpm start
sudo chkconfig php-fpm on
sudo service nginx start
sudo chkconfig nginx on
sudo service mariadb start
sudo chkconfig mariadb on

echo "Configuring DB"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;"

sudo mysql -u root < /databases/backup.sql

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "*/5 * * * * mysqldump --all-databases --result-file=/databases/backup.sql" >> mycron
#install new cron file
crontab mycron
rm mycron

sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf

fortune | cowsay -f stegosaurus

