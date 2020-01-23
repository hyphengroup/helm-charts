FROM php:7.3-apache-buster

# https://docs.suitecrm.com/admin/compatibility-matrix/
# PHP 7.3 supported starting with 7.11.5
ARG SUITECRM_VERSION=7.11.10

# Latest at 2020_01
ENV DOWNLOAD_URL http://downloads.sourceforge.net/project/suitecrm/SuiteCRM-${SUITECRM_VERSION}.zip?r=&ts=1458855387&use_mirror=iweb
ENV DOWNLOAD_FILE suitecrm-${SUITECRM_VERSION}.zip
ENV EXTRACT_FOLDER SuiteCRM-${SUITECRM_VERSION}
ENV WWW_USER www-data
ENV WWW_GROUP www-data

# libpng-dev required by gd
# libfreetype required by gd
# https://stackoverflow.com/a/38526260/138469 (required by imap extension)
# https://discuss.circleci.com/t/cannot-install-php-intl-on-php7-2-image/20528/5 - required for php-intl
RUN apt-get update \
    && apt-get install -y \
    cron \
    unzip \
    netcat \
    mariadb-client \
    gettext-base \
    procps \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    zlib1g-dev \
    libicu-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    g++ \
    --no-install-recommends \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*
    ## don't seem needed:
    # re2c \
    # graphviz \
    # libgmp-dev \
    # libldap2-dev \
    # libjpeg62-turbo-dev \

# To ensure cron works on all host kernels
# ref: https://stackoverflow.com/questions/21926465/issues-running-cron-in-docker-on-different-hosts
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

# a2enmod  is  a  script that enables the specified module within the apache2 configuration.
#      It does this by creating symlinks within  /etc/apache2/mods-enabled.
# base image config:
# ls -lah /etc/apache2/mods-enabled/*.load
#  /etc/apache2/mods-enabled/access_compat.load -> ../mods-available/access_compat.load
#  /etc/apache2/mods-enabled/alias.load         -> ../mods-available/alias.load
#  /etc/apache2/mods-enabled/auth_basic.load    -> ../mods-available/auth_basic.load
#  /etc/apache2/mods-enabled/authn_core.load    -> ../mods-available/authn_core.load
#  /etc/apache2/mods-enabled/authn_file.load    -> ../mods-available/authn_file.load
#  /etc/apache2/mods-enabled/authz_core.load    -> ../mods-available/authz_core.load
#  /etc/apache2/mods-enabled/authz_host.load    -> ../mods-available/authz_host.load
#  /etc/apache2/mods-enabled/authz_user.load    -> ../mods-available/authz_user.load
#  /etc/apache2/mods-enabled/autoindex.load     -> ../mods-available/autoindex.load
#  /etc/apache2/mods-enabled/deflate.load       -> ../mods-available/deflate.load
#  /etc/apache2/mods-enabled/dir.load           -> ../mods-available/dir.load
#  /etc/apache2/mods-enabled/env.load           -> ../mods-available/env.load
#  /etc/apache2/mods-enabled/filter.load        -> ../mods-available/filter.load
#  /etc/apache2/mods-enabled/mime.load          -> ../mods-available/mime.load
#  /etc/apache2/mods-enabled/mpm_prefork.load   -> ../mods-available/mpm_prefork.load
#  /etc/apache2/mods-enabled/negotiation.load   -> ../mods-available/negotiation.load
#  /etc/apache2/mods-enabled/php7.load          -> ../mods-available/php7.load
#  /etc/apache2/mods-enabled/reqtimeout.load    -> ../mods-available/reqtimeout.load
#  /etc/apache2/mods-enabled/setenvif.load      -> ../mods-available/setenvif.load
#  /etc/apache2/mods-enabled/status.load        -> ../mods-available/status.load

# deflate already enabled in base image and logs aleady simlinked...
# Timeout: The number of seconds before receives and sends time out.
#   default = 300
RUN set -ex \
    && . "/etc/apache2/envvars" \
    && a2enmod headers \
      expires \
      deflate \
      rewrite \
    && sed -i "s#Timeout .*#Timeout 600#" /etc/apache2/apache2.conf

# https://docs.suitecrm.com/admin/installation-guide/downloading-installing/#_recommended_installation_pre_requisites
RUN docker-php-ext-configure gd --with-freetype-dir \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      gd \
      imap \
      zip \
      intl \
      curl \
      mbstring \
      mysqli \
      pdo_mysql \
    #  ldap \
    #  bcmath \
    #  gmp \
    #  pcntl \
    #  pdo \
    && pecl update-channels \
    # problem for xdebug 2.6.1 with php 7.3rc (https://bugs.xdebug.org/view.php?id=1584)
    && pecl install xdebug-2.7.0beta1 \
    && pecl install redis \
	&& rm -rf /tmp/pear ~/.pearrc \
    && docker-php-ext-enable redis

# Download suiteCRM to /var/www/html
WORKDIR /tmps
RUN curl -o $DOWNLOAD_FILE -L "${DOWNLOAD_URL}" && \
  unzip $DOWNLOAD_FILE && \
  rm $DOWNLOAD_FILE && \
  rm -rf /var/www/html/* && \
  cp -R ${EXTRACT_FOLDER}/* /var/www/html/ && \
  rm -rf ${EXTRACT_FOLDER} && \
  chown -R ${WWW_USER}:${WWW_GROUP} /var/www/html/* && \
  chown -R ${WWW_USER}:${WWW_GROUP} /var/www/html && \
  chmod 777 -R /var/www/html
WORKDIR "/var/www/html"

# configure php
COPY conf/docker.ini /usr/local/etc/php/conf.d/

# Install crontab (entrypoint needs to start cron in background)
RUN (crontab -l 2>/dev/null; echo "* * * * *  php -f /var/www/html/cron.php > /dev/null 2>&1 ") | crontab -

# COPY docker-entrypoint.sh /
COPY conf/config_si.php /

EXPOSE 80
ENTRYPOINT ["apache2-foreground"]
