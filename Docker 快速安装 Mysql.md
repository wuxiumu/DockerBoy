本篇文章主要记录 Docker 安装 Mysql 的命令和过程。在开始之前，你需要在电脑上安装 Docker 环境，可参考

[在 CentOS 系统上安装 Docker Engine](https://link.zhihu.com/?target=https%3A//juejin.im/post/6859664125308436487)

[在 Ubuntu 上安装 Docker Engine](https://link.zhihu.com/?target=https%3A//juejin.im/post/6871477974458171405)

本教程适应于 CentOS 与 Ubuntu 系统。

## **配置阿里云镜像加速**

Docker 镜像源在国外，国内访问速度非常慢，要想获得更高的下载速度需要配置国内镜像源。

进入阿里云镜像加速配置页面 [https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors](https://link.zhihu.com/?target=https%3A//cr.console.aliyun.com/cn-hangzhou/instances/mirrors) （需要登录）获取你账号下的加速地址

通过修改 daemon 配置文件 `/etc/docker/daemon.json` 来使用加速器

如下是 CentOs、Ubuntu 系统的配置命令，请将镜像加速地址（代码中的不可用）换成你自己的地址 罒ω罒

```text
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kwli5l3lxi5a0mx.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

查看其它系统的镜像加速配置请查阅阿里云镜像加速文档

## **Docker 安装 Mysql**

进入 [https://hub.docker.com/](https://link.zhihu.com/?target=https%3A//hub.docker.com/) 查找需要安装的镜像，选择合适的版本

如搜索 mysql 显示 [https://hub.docker.com/_/mysql?tab=tags](https://link.zhihu.com/?target=https%3A//hub.docker.com/_/mysql%3Ftab%3Dtags)

直接复制命令即可

```text
$ docker pull mysql:8
```

拉取镜像成功后可查看本地拉取的镜像

```text
$ docker images
```

快速安装一般不需要挂载配置，如需挂载配置文件，需要查看当前版本 Mysql 的配置文件路径及文件名。

创建测试容器实例并启动

```text
$ docker run -p 3306:3306 --name mysqltest -e MYSQL_ROOT_PASSWORD=root -d mysql:8

```

参数说明：

```text
- p 3306:3306 : 将容器的 3306 端口映射到主机的 3306 端口
- e MYSQL_ROOT_PASSWORD=root : 设置 mysql 登录密码
- d 后台运行容器，并返回容器 id
mysql:8 我运行的镜像名，也可替换成镜像 id
```



### **进入 Mysql 容器**

```text
$ docker exec -it mysqltest bash
```

### **确定 Docker 内 MySQL 文件相关路径**

```text
# 查找Docker内，MySQL配置文件my.cnf的位置
mysql --help | grep my.cnf
# 若找不到 my.cnf，使用 whereis 命令查找相关配置路径
whereis mysql
```

### **创建本地路径并挂载 Docker 内数据**

先执行 `exit` 退出 mysql 容器

创建本地文件夹，可自己规划路径

```text
$ mkdir -p /root/docker/mysql/conf
```

将测试容器里 MySQL 的配置文件复制到该路径。日后需改配置，直接在挂载路径的配置文件上修改即可　　

```text
$ docker cp mysqltest:/etc/mysql/my.cnf /root/docker/mysql/conf
```

删除测试容器，创建新的 docker 容器并启动

```text
$ docker run -p 3306:3306 --name mysql \
-e MYSQL_ROOT_PASSWORD=root \
-v /root/docker/mysql/conf/my.cnf:/etc/mysql/my.cnf \
-d mysql:8 
```

参数说明：

```text
- p 3306:3306 : 将容器的 3306 端口映射到主机的 3306 端口
- v /dockerData/mysql/conf:/etc/mysql : 将配置文件挂载到主机
- e MYSQL_ROOT_PASSWORD=root : 设置 mysql 登录密码
- d 后台运行容器，并返回容器 id
mysql:8 我运行的镜像名，也可替换成镜像 id
```

## **查看是否启动成功**

我们可以采用 `docker ps` 命令查看是否运行了目标容器。

可以等待一段时间后运行该命令，因为 Docker 容器启动需要一定的时间。

启动过程中容器会显示正在运行，但遇到错误时容器会停止。

当我们发现容器不运行后需要进行排错，我们可以查看容器的启动日志来发现错误信息。

```text
# 其中 id 需要替换为容器启动后返回的容器 id
$ docke logs id
```

通过查看错误信息进行网上搜索从而进行处理。

## **连接 Mysql 数据库**

我们可以在其他电脑上通过数据库连接软件连接 Docker 运行的 Mysql 服务器。

例如我们可以通过 Navicat 连接数据库，在连接之前确保你的 Mysql 容器正常启动。

**报错：Navicat 不支持 caching_sha_password 加密方式**

Mysql 8 安装后采用 Navicat 进行连接可能会报 “navicat 不支持 caching_sha_password 加密方式” 错误。采用如下方式解决：

进入容器

```text
$ docker exec -it mysql bash
```

登录 Mysql

```text
 $ mysql -uroot -p
```

查看并选择数据库

```text
$ show databases;
$ use mysql
```

修改加密方式并退出 Mysql 和 Mysql 容器

```text
$ select host,user,plugin from user;
$ alter user 'root'@'%' identified with mysql_native_password by 'root';
$ exit;
$ exit;
```

## **容器内修改配置文件**

若创建容器时没有挂载相关配置文件，需要到容器内部进行配置文件的修改。

进入容器命令：

```text
$ docker exec -it 容器名/容器id bash
```

Docker 容器默认没有安装 vim ，需要进行手动安装，按照系统执行如下命令即可。

Ubuntu 系统

```text
$ apt-get update
$ apt install vim 
```

CentOs 系统

```text
$ yum -y install vim*
```

## **宿主机与容器之间文件拷贝**

在实际操作中，我们常常需要在宿主机与容器之间进行文件的复制。

### **从宿主机复制到容器**

```text
$ docker cp 宿主机本地路径 容器名字/ID：容器路径

$ docker cp /root/123.cnf mysql:/etc/mysql
```

### **从容器复制到宿主机**

```text
$ docker cp 容器名字/ID：容器路径 宿主机本地路径

$ docker cp mysql:/etc/mysql/my.cnf /root

```