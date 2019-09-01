FROM centos:7
MAINTAINER ctwj 908504609@qq.com

COPY mongodb-org-4.0.repo /etc/yum.repos.d/mongodb-org-4.0.repo
COPY tideways.repo /etc/yum.repos.d/tideways.repo
RUN rpm --import https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg \
    && yum makecache --disablerepo=* --enablerepo=tideways && yum update

RUN yum -y install unzip gcc make autoconf wget gcc-c++ glibc-headers openssl-devel git \
    && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm 

# php
RUN yum -y install php72w php72w-bcmatch php72w-cli php72w-common php72w-dba php72w-devel php72w-embedded php72w-enchant php72w-fpm \
    && yum -y install php72w-gd php72w-imap php72w-mbstring php72w-mysqlnd php72w-pecl-imagick php72w-pecl-geoip php72w-pecl-apcu \
    && yum -y install php72w-pecl-memcached php72w-pecl-mongodb php72w-pecl-redis php72w-pgsql php72w-xml \
    && yum -y install php72w-xmlrpc

# swoole
RUN cd ~ && wget https://github.com/swoole/swoole-src/archive/v4.3.1.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -rf swoole.tar.gz && cd swoole && phpize && ./configure --enable-async-redis --enable-mysqlnd --enable-coroutine --enable-openssl --enable-http2 --with-php-config=/usr/bin/php-config \
    && make && make install && echo extension=swoole.so > /etc/php.d/swoole.ini 

# composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer self-update --clean-backups \
    && rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
    && yum install -y nginx 

# superviosr tideways mongodb
RUN yum -y install supervisor  mongodb-org tideways-php tideways-cli tideways-daemon \
    && mkdir -p /data/mongodb

# xhgui
RUN cd ~ && git clone https://github.com/perftools/xhgui \
    && mv  xhgui /var/www/xhgui && cd /var/www/xhgui/ && composer install --prefer-dist \
    && chmod -R 777 /var/www/xhgui

# xdebug
RUN yum -y install php72w-pecl-xdebug

COPY xdebug.ini  /etc/php.d/xdebug.ini
COPY xhgui.conf /etc/nginx/conf.d/xhgui.conf
COPY web.conf /etc/nginx/conf.d/default.conf
COPY supervisord-fpm.conf /etc/supervisord.conf
COPY start.sh /root/start.sh
COPY index.php /var/www/html/index.php

WORKDIR /var/www/html
EXPOSE 88 99
ENTRYPOINT ["/bin/sh", "/root/start.sh"]
