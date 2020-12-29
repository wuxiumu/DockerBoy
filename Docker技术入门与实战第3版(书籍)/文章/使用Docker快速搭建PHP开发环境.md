# [使用Docker快速搭建PHP开发环境](https://www.cnblogs.com/cocowool/p/docker-php-dev.html)

最近有个同事找过来，希望我对在很早之前写的一个PHP网站上增加一些功能，当时开发使用`xampp`构建的本地开发环境，但是现在我的笔记本电脑已经更新，没有当时的开发环境。本着尽量不往电脑上装无用软件的原则，想到能不能用Docker来构建本地开发环境，因此本文介绍了如何基于Docker来快速构建本地`PHP`开发环境，供有需要的同学参考使用。



目录

- [前期准备](https://www.cnblogs.com/cocowool/p/docker-php-dev.html#前期准备)
- [编排文件](https://www.cnblogs.com/cocowool/p/docker-php-dev.html#编排文件)
- [运行效果](https://www.cnblogs.com/cocowool/p/docker-php-dev.html#运行效果)
- [安装扩展](https://www.cnblogs.com/cocowool/p/docker-php-dev.html#安装扩展)
- [参考资料](https://www.cnblogs.com/cocowool/p/docker-php-dev.html#参考资料)



> 本文基于 `5.6-fpm-alpine3.8` 以及 `ngingx` 搭建Mac 下的PHP开发环境。

## 前期准备

首先下载所需要的镜像文件

```sh
$ docker pull php:5.6-fpm-alpine3.8
$ docker pull nginx
$ docker pull mysql
```

> 用户需要到[hub.docker.com](https://hub.docker.com/)，搜索PHP并通过tags找到自己希望安装的版本，我的项目因为开发时间比较久了，不能够支持最新的PHP，所以安装的是5.6版本。

我们需要准备一个工作目录，例如`lnmp`，在工作目录下准备网站根目录、Nginx配置文件目录、Nginx日志目录。

```sh
$ mkdir lnmp
$ cd lnmp
$ mkdir -p nginx/www nginx/logs nginx/conf
```

在`nginx/conf`目录下准备`nginx`的配置文件php.conf。

```
server {
	listen	80;
	server_name	localhost;

	location / {
		root	/usr/share/nginx/html;
		index	index.html index.htm index.php;
	}

	error_page	500 502 503 504	/50x.html;
	location = /50x.html {
		root	/usr/share/nginx/html;
	}

	location ~ \.php$ {
		fastcgi_pass	php:9000;
		fastcgi_index	index.php;
		fastcgi_param	SCRIPT_FILENAME	/www/$fastcgi_script_name;
		include		fastcgi_params;
	}
}
```

## 编排文件

在工作目录下创建`docker-compose.yml`编排文件。

> 关于`docker-compose`的详细介绍可以参考我之前的文章[docker-compose 使用介绍](http://edulinks.cn/2020/04/15/20200415-docker-compose/)。

```yaml
version: "2.1"
services:
    nginx:
        image: nginx
        ports:
            - "80:80"
        volumes: 
            - ~/Projects/sh-valley/docker-conf/lnmp/nginx/www:/usr/share/nginx/html
            - ~/Projects/sh-valley/docker-conf/lnmp/nginx/conf:/etc/nginx/conf.d
            - ~/Projects/sh-valley/docker-conf/lnmp/nginx/logs:/var/log/nginx
        networks:
            - lnmp-network
    php:
        image: php:5.6-fpm-alpine3.8
        volumes:
            - ~/Projects/sh-valley/docker-conf/lnmp/nginx/www:/www
        networks:
            - lnmp-network
    mysql:
        image: mysql
        ports:
            - "3306:3306"
        environment:
            - MYSQL_ROOT_PASSWORD=123456
        networks:
            - lnmp-network
networks: 
    lnmp-network:
```

至此，我们完成了所有的准备工作，马上可以启动查看效果。

## 运行效果

```sh
$ docker-compose up -d
Creating network "lnmp_php-network" with the default driver
Creating lnmp_nginx_1 ... done
Creating lnmp_php_1   ... done
```

马上就能看到熟悉的`phpinfo`界面了。

![img](https://img2020.cnblogs.com/blog/39469/202004/39469-20200419152131911-610640400.png)

## 安装扩展

默认`php`镜像中提供的扩展比较少，缺少诸如`mysql、gd2`等常用的扩展，这样我们就需要自己安装并启用扩展。

首先进入到`php`容器，用`php -m`命令查看本地有什么扩展。

可以使用`docker-php-ext-install`命令来安装扩展。

```sh
$ docker-php-ext-install mysql
```

扩展安装好之后就可以在`php.ini`中启用。我们从`phpinfo`中可以看到，容器环境下默认的`php.ini`没有启用，可以从`/usr/local/etc/php`下将`php.ini-development`拷贝为`php.ini`。通过修改`php.ini`中配置，启用自己需要的扩展。下面是几个扩展安装的命令，供大家参考。

- `docker-php-ext-source` 在容器中创建一个`/usr/src/php`目录
- `docker-php-ext-enable`启用PHP扩展，省去我们手工编辑`php.ini`的过程
- `docker-php-ext-install`安装并启用PHP扩展
- `docker-php-ext-configure`经常与`docker-php-ext-install`搭配，在需要自定义扩展的配置时使用