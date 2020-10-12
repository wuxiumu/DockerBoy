# [Docker启动Get Permission Denied](https://www.cnblogs.com/informatics/p/8276172.html)

以下问题及解决方法都在Ubuntu16.04下，其他环境类似

## 问题描述

安装完docker后，执行docker相关命令，出现

```
”Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.26/images/json: dial unix /var/run/docker.sock: connect: permission denied“
```

## 原因

摘自docker mannual上的一段话

```
Manage Docker as a non-root user

The docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user root and other users can only access it using sudo. The docker daemon always runs as the root user.

If you don’t want to use sudo when you use the docker command, create a Unix group called docker and add users to it. When the docker daemon starts, it makes the ownership of the Unix socket read/writable by the docker group.
```

大概的意思就是：docker进程使用Unix Socket而不是TCP端口。而默认情况下，Unix socket属于root用户，需要root权限才能访问。

## 解决方法1

使用sudo获取管理员权限，运行docker命令

## 解决方法2

docker守护进程启动的时候，会默认赋予名字为docker的用户组读写Unix socket的权限，因此只要创建docker用户组，并将当前用户加入到docker用户组中，那么当前用户就有权限访问Unix socket了，进而也就可以执行docker相关命令

```
sudo groupadd docker     #添加docker用户组
sudo gpasswd -a $USER docker     #将登陆用户加入到docker用户组中
newgrp docker     #更新用户组
docker ps    #测试docker命令是否可以使用sudo正常使用
```

作者：[warm3snow](http://www.cnblogs.com/informatics/)

出处：http://www.cnblogs.com/informatics/

本文版权归作者和博客园共有，欢迎转载，但未经作者同意必须在文章页面给出原文连接，否则保留追究法律责任的权利。

分类: [Linux](https://www.cnblogs.com/informatics/category/748912.html), [云原生应用与容器技术](https://www.cnblogs.com/informatics/category/1060346.html)



# 问题记录：Docker daemon socket权限不足



方案一：使用sudo获取管理员权限，运行docker命令
方案二：添加docker group组，将用户添加进去

```
songyanyan@songyanyan:~$ sudo group add docker
[sudo] songyanyan 的密码： 
sudo: group：找不到命令
songyanyan@songyanyan:~$ sudo groupadd docker #添加docker用户组
groupadd：“docker”组已存在
songyanyan@songyanyan:~$ sudo gpasswd -a $USER docker #将登陆用户加入到docker用户组中
正在将用户“songyanyan”加入到“docker”组中
songyanyan@songyanyan:~$ newgrp docker #更新用户组
songyanyan@songyanyan:~$ docker ps #测试当前用户是否可以正常使用docker命令
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
songyanyan@songyanyan:~$ 
```

