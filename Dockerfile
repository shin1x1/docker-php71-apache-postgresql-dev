FROM php:7.1-apache

MAINTAINER Masashi Shinbara <shin1x1@gmail.com>

# Install PHP extensions
RUN apt-get update && apt-get install -y \
      libicu-dev \
      libpq-dev \
      git \
      ssh \
      rsync \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install \
      intl \
      pcntl \
      pdo_pgsql \
      pgsql \
      zip \
      opcache \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install Deployer
RUN curl -LO https://deployer.org/deployer.phar \
    && mv deployer.phar /usr/bin/dep \
    && chmod +x /usr/bin/dep

# Put apache config for Laravel
COPY apache2-laravel.conf /etc/apache2/sites-available/laravel.conf
RUN a2dissite 000-default.conf && a2ensite laravel.conf && a2enmod rewrite

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

WORKDIR /var/www/html