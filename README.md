# docker-nginx-php7


## 容器包含的内容

0. php72
1. 几乎所有的 php 扩展
2. swoole 4.3.1
3. composer
4. nginx
5. tideways + xhgui   用于性能监控
6. mongodb            給 xhgui 提供存储
7. supervisor         用于管理 nginx php-fpm  MongoDB
8. xdebug

## 使用

启动开发环境
```
docker run -d -p 80:80 -v /web/dir:/var/www/html --name dev ctwj/nginx_php7
```

保存tideways调试信息
```
docker run -d -p 80:80 -p 88:88 -v /web/dir:/var/www/html -v /debug/store:/data/mongodb --name dev ctwj/nginx_php7
```

网站访问：
> http://localhost

性能监控:
> http://localhost:88

xdebug断点调试

使用docker-compose 添加数据庫支持
```
version: "2"
services:
  mysql:
    image: mariadb
    restart: always
    container_name: "xdb"
    expose:
      - 3306
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=gooljam
    volumes:
      - ./docker/mysql:/var/lib/mysql

  web:
    image: ctwj/nginx_php7
    container_name: "xweb"
    ports:
      - 60000:80
      - 60001:88
    volumes:
      - .:/var/www/html
      - ./docker/mongodb:/data/mongodb
    links:
      - mysql:mysql
```


