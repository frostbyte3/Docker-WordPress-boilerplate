FROM wordpress:php7.2-apache

MAINTAINER Mitch Lewis <mitch@buzbiz.com>

ARG DEBIAN_FRONTEND=noninteractive

# system configuration
RUN apt-get -y update && apt-get -y upgrade \
    && apt-get -y install curl git zip unzip \
    && usermod -u 1000 www-data \
    && a2enmod expires && a2enmod headers && a2enmod rewrite \
    && sed -i -e 's/None/All/g' /etc/apache2/apache2.conf \
    && docker-php-ext-install pdo pdo_mysql

# code configuration
COPY ./src /var/www/html

CMD ["bash", "/code/init.sh"]