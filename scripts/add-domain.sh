#!/bin/bash

sudo groupadd -f $1
sudo id -u $1 &>/dev/null || useradd -d /var/www/vhosts/$1 -g $1 $1

if [ ! -e /etc/nginx/conf.d/$1.conf ]
then
cat > /etc/nginx/conf.d/$1.conf <<EOF
upstream $1backend {
    server unix:/var/run/php-fcgi-$1.sock;
}

server {
    autoindex on;
    listen 80;
    server_name $1;
    root /var/www/vhosts/$1/htdocs;
    index index.php;
    access_log /var/www/vhosts/$1/logs/access.log;
    error_log /var/www/vhosts/$1/logs/error.log;

    location / {
        fastcgi_pass   $1backend;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        include        fastcgi_params; 
        try_files      \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ /.well-known {
        allow all;
    }

   location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
       expires max;
       log_not_found off;
   }
}

EOF
fi

if [ ! -e /etc/php-fpm.d/$1.conf ]
then

cat > /etc/php-fpm.d/$1.conf <<EOF
[$1]

listen = /var/run/php-fcgi-$1.sock

listen.allowed_clients = 127.0.0.1

user = $1
group = $1
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5

pm.max_spare_servers = 35
slowlog = /var/log/php-fpm/www-slow.log
php_admin_value[error_log] = /var/www/vhosts/$1/fpm-error.log
php_admin_flag[log_errors] = on

php_value[session.save_handler] = files
php_value[session.save_path] = /var/log/php-fpm
EOF

fi

mkdir -p /var/www/vhosts/$1/htdocs
mkdir -p /var/www/vhosts/$1/logs
mkdir -p /var/www/vhosts/$1/tmp
