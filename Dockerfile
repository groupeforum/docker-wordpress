FROM php:5.6-apache

MAINTAINER Florian Girardey <florian@girardey.net>

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mysqli

# Install xdebug
RUN pecl install xdebug \
	&& echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini

# Fix permissions on all of the files
RUN usermod -u 1000 www-data

# Setup APACHE environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Update the default apache site with the config we created.
COPY apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Add PHP Configuration file
COPY php.ini /usr/local/etc/php/conf.d/wordpress.ini

VOLUME /var/www/html

CMD ["apache2-foreground"]
