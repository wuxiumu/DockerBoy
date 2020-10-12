```
docker run -p 9001:9000 --name myphp74 \
-v /home/wqb/Work/Docker/php7:/var/www/html/ \
--privileged=true \
-d php:7.4.8

php:7.4.8
nginx:1.19.1

#查看php镜像的ip地址
docker inspect --format='{{.NetworkSettings.IPAddress}}' myphp
 
172.17.0.2
 
#修改default.conf配置文件，使fastcgi_pass的值为 172.17.0.2:9000
 
vim /docker/nginx/conf.d/default.conf
 
fastcgi_pass 172.17.0.2:9000;
```

利用docker搭建php7和nginx运行环境

https://blog.csdn.net/u013829518/article/details/88711641

```
docker run --network lnmp --name mysql -v /home/lnmp/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d --privileged=true mysql
### 命令说明：
--network :将mysql容器在私有网络中运行
--name 给容器指定别名
-v /home/lnmp/mysql/:/var/lib/mysql：将主机当前用户目录下的mysql文件夹挂载到容器的/var/lib/mysql 下，在mysql容器中产生的数据就会保存在本机mysql目录下
-e MYSQL_ROOT_PASSWORD=123456：初始化root用户的密码
-d 后台运行容器
--privileged=true  可能会碰到权限问题，需要加参数

docker run --network lnmp --name mysql -v /home/lnmp/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d --privileged=true mysql

docker run --name mynginx -p 8080:80 -d -v /home/lnmp/nginx/html:/usr/share/nginx/html -d nginx:1.19.1


docker stop mynginx #停止容器

docker rm mynginx #删除容器

docker run --name mynginx -p 8080:80 --network lnmp -v /home/lnmp/nginx/html:/usr/share/nginx/html -v  /home/lnmp/nginx/conf.d:/etc/nginx/conf.d/ -d nginx:1.19.1

docker run --name myphp -p 9001:9001 --network lnmp -d php:7.4.8

docker cp myphp:/usr/src/php-7.1.33/php.ini-production php.ini

docker run --name myphp --network lnmp -v /home/lnmp/nginx/html:/var/www/html -v /home/lnmp/php/www.conf:/usr/local/etc/php-fpm.d/www.conf -v /home/lnmp/php/php.ini:/usr/local/etc/php/php.ini -d php:7.1-fpm

docker run --name mynginx -p 8080:80 --network lnmp -v /home/lnmp/nginx/html:/usr/share/nginx/html -v  /home/lnmp/nginx/conf.d:/etc/nginx/conf.d/ -d nginx:1.19.1

docker run --name mynginx --network lnmp -v /home/lnmp/nginx/html:/usr/share/nginx/html -v  /home/lnmp/nginx/conf.d:/etc/nginx/conf.d/ -d nginx:1.19.1

docker run --name mynginx2 -p 8080:80 --network lnmp -v /home/lnmp/nginx/html:/usr/share/nginx/html -v  /home/lnmp/nginx/conf.d:/etc/nginx/conf.d/ -d nginx:1.19.1
```

```
停止nginx

nginx -s stop

重启nginx

nginx -s reload

1、查看是否已经开启

ps -ef|grep php

2、查看php安装目录

whereis php

3、开启php-fpm服务

service php-fpm start

4、关闭php-fpm服务

pkill php-fpm


http://172.18.0.3/

Composer detected issues in your platform: Your Composer dependencies require a PHP version ">= 7.2.5" and "< 8.0.0". You are running 7.1.33.

docker run --name myphp73 --network lnmp -d php:7.3.5-fpm

docker cp myphp73:/usr/local/etc/php/php.ini-production php.ini

docker run --name myphp73 --network lnmp -v /home/lnmp/nginx/html:/var/www/html -v /home/lnmp/php73/www.conf:/usr/local/etc/php-fpm.d/www.conf -v /home/lnmp/php73/php.ini:/usr/local/etc/php/php.ini -d php:7.3.5-fpm

docker run --name myphp73 --network lnmp -v /home/lnmp/nginx/html:/var/www/html -v /home/lnmp/php73/php.ini:/usr/local/etc/php/php.ini -d php:7.3.5-fpm
```

