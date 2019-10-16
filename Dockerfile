FROM php:7.3-apache

LABEL maintainer="SandyMadaan"

COPY vhost.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

EXPOSE 80

WORKDIR /var/www/html

RUN apt-get -y update \
    && apt-get install -y git unzip libicu-dev libpq-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl mbstring pdo pdo_mysql pdo_pgsql

RUN apt-get -y update \
    && apt-get -y install gcc g++ make autoconf libc-dev pkg-config

RUN apt-get -y install libz-dev libpcre2-dev automake

RUN apt-get -y install lsb-release apt-transport-https ca-certificates curl sudo
RUN apt-get -y install wget

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php7.3.list

RUN apt-get -y update

RUN apt -y update

RUN apt -y install apt-utils

RUN apt policy php7.3-cli

RUN apt policy php7.3-dev

RUN apt policy php-pear

RUN pecl install grpc


RUN bash -c "echo extension=grpc.so > /usr/local/etc/php/conf.d/grpc.ini"

RUN service apache2 restart

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
