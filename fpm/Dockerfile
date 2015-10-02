FROM php:5.6-fpm

MAINTAINER Florian Girardey <florian@girardey.net>

# install the PHP extensions we need
RUN apt-get update && apt-get install -q -y libpng12-dev libjpeg-dev exim4 mailutils \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install opcache
RUN docker-php-ext-install mysqli

# Install xdebug
RUN pecl install xdebug

# Add PHP Configuration file for OPcache
COPY php-opcache.ini /usr/local/etc/php/conf.d/php-opcache.ini

# Add PHP Configuration file for WordPress
COPY php-wordpress.ini /usr/local/etc/php/conf.d/php-wordpress.ini

# Add PHP Configuration file for SMTP
COPY php-smtp.ini /usr/local/etc/php/conf.d/php-smtp.ini

# Add the Entrypoint script
COPY docker-entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

VOLUME /var/www/html

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["php-fpm", "-F"]
