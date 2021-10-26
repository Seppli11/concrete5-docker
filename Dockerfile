FROM php:7.4-apache

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get -y install vim && apt-get clean && rm -r /var/lib/apt/lists/*

RUN install-php-extensions gd zip pdo_mysql


RUN cd / && composer create-project concrete5/composer concrete5

RUN mkdir /concrete5/public/updates && chown  www-data /concrete5/public/application/files  /concrete5/public/application/config /concrete5/public/packages /concrete5/public/updates

RUN  chmod 755 /concrete5/public/application/files/ && \
	chmod 755 /concrete5/public/application/config/ && \
	chmod 755 /concrete5/public/packages/ && \
	chmod 755 /concrete5/public/updates/


ENV APACHE_DOCUMENT_ROOT /concrete5/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
	 sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
