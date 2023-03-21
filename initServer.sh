#!/bin/bash
sudo apt -y update && sudo apt -y dist-upgrade && sudo apt -y autoremove && sudo apt-get update

#install & enable apache
sudo apt -y install apache2 -y
sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/apache2/apache2.conf
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service

#install php & req libs
sudo apt -y install php libapache2-mod-php php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl

#configure php
sudo nano /etc/php/7.2/apache2/php.ini

#download server code from git
sudo rm /var/www/html/index.html
sudo git clone WP_GIT_REPO /var/www/html/

#configure dbs
sudo apt -y install mysql-client mysql-server

#configure wordpress
sudo nano /etc/apache2/sites-available/HOST.conf
sudo a2ensite HOST.conf
sudo a2enmod rewrite
sudo chown -R www-data:www-data /var/www/ROOT_DIR/
sudo chmod -R 755 /var/www/ROOT_DIR/
sudo systemctl reload apache2.service

#install composer
cd /var/www/html
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

#configure ssl
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-apache
sudo certbot --apache

sudo echo "<VirtualHost *:80>
ServerAdmin mitch@buzbiz.com
ServerName HOST
ServerAlias HOST
DocumentRoot /var/www/html/

<Directory /var/www/html>
     Options Indexes FollowSymLinks
     AllowOverride All
     Require all granted
</Directory>

ErrorLog ${APACHE_LOG_DIR}/HOST_error.log 
CustomLog ${APACHE_LOG_DIR}/HOST_access.log combined 
RewriteEngine on
RewriteCond %{SERVER_NAME} =HOST
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>" > /etc/apache2/sites-available/HOST.conf