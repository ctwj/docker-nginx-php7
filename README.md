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

启动调试
```
远程端口：9001
```

vscode
1. 安装 PHP Debug 插件
2. 选择左侧调试功能，添加环境选择php
3. 在打开的配置文件`launch.json`中修改端口为9001


