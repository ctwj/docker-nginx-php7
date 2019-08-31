FROM centos:7
MAINTAINER ctwj 908504609@qq.com

RUN yum update

RUN yum -y install unzip gcc make autoconf gcc-c++ glibc-headers openssl-devel git \
    && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm 

RUN yum -y install php72w php72w-*

RUN cd ~ && wget https://github.com/swoole/swoole-src/archive/v4.3.1.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -rf swoole.tar.gz && cd swoole && phpize && ./configure --enable-async-redis --enable-mysqlnd --enable-coroutine --enable-openssl --enable-http2 --with-php-config=/usr/bin/php-config \
    && make && make install && echo extension=swoole.so > /etc/php.d/swoole.ini 

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer self-update --clean-backups \
    && rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
    && yum install -y nginx 


COPY web.conf /etc/nginx/conf.d/nginx.conf
COPY supervisord-fpm.conf /etc/supervisord.conf
COPY start.sh /root/start.sh

WORKDIR /var/www/html
EXPOSE 88
ENTRYPOINT ["/bin/sh", "/root/start.sh"]
