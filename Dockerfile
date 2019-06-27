FROM php:7.2-apache

COPY . /var/www

############################################################################
# Configure Apache web-server
############################################################################
RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's/html/public/g' /etc/apache2/sites-enabled/000-default.conf

############################################################################
# Install required tools and libraries
############################################################################
RUN apt-get update \
    && apt-get install -y wget git zip zlib1g-dev \
    && docker-php-ext-install pcntl

############################################################################
# Install Composer
############################################################################
RUN mkdir -p /root/bin \
    && cd /root/bin \
    && wget https://getcomposer.org/installer \
    && php installer \
    && rm installer \
    && mv composer.phar composer \
    && chmod u+x composer
ENV PATH /var/www/vendor/bin:/var/www/bin:/root/bin:~/.composer/vendor/bin:$PATH

#############################################################################
## Setup XDebug, always try and start XDebug connection to Docker host
#############################################################################
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.auto_trace=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && sed -i '2iexport HOST=$(printf "%d.%d.%d.%d" $(awk \x27$2 == 00000000 && $7 == 00000000 { for (i = 8; i >= 2; i=i-2) { print "0x" substr($3, i-1, 2) } }\x27 /proc/net/route))' /usr/local/bin/apache2-foreground \
    && sed -i '3iexport XDEBUG_CONFIG="remote_host=${HOST}"' /usr/local/bin/apache2-foreground

WORKDIR /var/www