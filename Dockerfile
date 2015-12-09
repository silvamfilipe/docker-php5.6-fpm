# Base image
FROM php:5.6-fpm
MAINTAINER Filipe Silva <silvam.filipe@gmail.com>

RUN echo "phar.readonly = off" > /usr/local/etc/php/conf.d/phar.ini

# Add configs
COPY etc/*.ini /usr/local/etc/php/
RUN cd /usr/local/etc/php && cp development.ini conf.d/environment.ini
RUN mkdir -p /usr/local/etc/fpm.d && \
    echo "catch_workers_output = yes" > /usr/local/etc/fpm.d/logging.conf && \
    echo "\ninclude=/usr/local/etc/fpm.d/*.conf" >> /usr/local/etc/php-fpm.conf && \
    sed -i -e "s/^pm = dynamic/pm = ondemand/" /usr/local/etc/php-fpm.conf

# Add entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
WORKDIR /var/www

CMD ["php-fpm"]