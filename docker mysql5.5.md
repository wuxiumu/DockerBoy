docker mysql5.5

```
docker run  --name mysql55 -v /home/wqb/Docker_data/dbmysql55/mysql/data:/var/lib/mysql -p 33065:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.5
```

ocker作为一种容器技术可以方便的运行各种软件，这里记录一下如何运行mysql5.5

## 操作

### 安装docker

```
curl -fsSL https://get.docker.com | sudo bash
```

### 拉取mysql5.5镜像

```
docker pull mysql:5.5
```

### 运行mysql5.5

```
docker run  --name mysql55 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.5
```

参数：

- `--name`：指定容器名 ，这里是mysql
- `-p 3306:3306`：将容器的 3306 端口映射到主机的 3306 端口。
- `-e MYSQL_ROOT_PASSWORD=123456`：设置环境变量 ，这里是初始化 root 用户的密码。
- `-d`: 后台运行容器，并返回容器ID
- `mysql:5.5`：表示你之前下载的镜像。它表示使用 `mysql:5.5`该镜像为基础来启动容器。
- 更多参数请参考：https://hub.docker.com/_/mysql/

> `mysql:5.5`对应的格式为 `mysql:tag` ，使用该格式表示某镜像，即：`容器名: 版本` 。

### 更多设置

将数据目录挂载到宿主机，可以使用以下参数

```
-v /etc/docker/mysql/data:/var/lib/mysql
```

`-v`参数即可将容器里面的目录挂载到宿主机。
`:`前是本机目录，可修改。
将数据库字符集设置为utf8，可以使用以下参数

```
 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

对于容器的修改，可以通过`docker stop 容器名`然后运行`docker rm 容器名`最后运行`docker run 参数`来实现。
参考链接：
[使用Docker安装mysql 5 和 mysql 8](https://www.jianshu.com/p/d297b0be4157)



## 安装 mysql 5.5

该镜像在Docker Hub上的地址为：[library/mysql](https://hub.docker.com/r/library/mysql/) ，打开该连接，默认展示 Repo info 标签页（该标签页中包含了一些操作该容器的方法）中的内容，如果想查看该image大小和各标签，可切换到 "Tags"标签页查看。

**拉取镜像：**



```css
docker pull mysql:5.5.60
```

**运行容器：**

这里只是个简单示例，先用于理解各个参数的含义，完整的命令见后文：



```undefined
docker run   --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=fan123 -d mysql:5.5.60
```

- `--name`：指定容器名 ，这里是mysql
- `-p 3306:3306`：将容器的 3306 端口映射到主机的 3306 端口。
- `-e MYSQL_ROOT_PASSWORD=123456`：设置环境变量 ，这里是初始化 root 用户的密码。
- `-d`:  后台运行容器，并返回容器ID
- `mysql:5.5.60`：表示你之前下载的镜像。它表示使用 `mysql:5.5.60`该镜像为基础来启动容器。

> `mysql:5.5.60`对应的格式为 `mysql:tag` ，使用该格式表示某镜像，即：`容器名: 版本` 。

示例



```shell
# 运行容器
$ docker run  --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.5.60
a936fdfe89b527e1ea9bdca45014112e502572d10d35638cba257175b092a2f8
# 查看该容器
$ docker container ls
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
a936fdfe89b5        mysql:5.5.60         "docker-entrypoint.s…"   10 seconds ago      Up 5 seconds        0.0.0.0:3306->3306/tcp   mysql
```

**进入mysql容器：**

在使用`-d`参数时，容器启动后会进入后台。如果此时需要进入容器进行操作，可以使用`docker exec`命令.



```shell
# 先查看运行中的容器
$ docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
a936fdfe89b5        mysql:5.5.60        "docker-entrypoint.s…"   39 minutes ago      Up 39 minutes       0.0.0.0:3306->3306/tcp   mysql
# 可以看到mysql容器的短id值，这里我们取前4位即可辨识
# 使用docker exec进入容器， -it 表示交互式终端  bash 表示使用熟悉的Linux命令提示符形式
$ docker exec -it a936 bash
root@a936fdfe89b5:/#
# 然后运行如下命令连接mysql
root@a936fdfe89b5:/# mysql -uroot -p12345
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.5.60 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

终止mysql容器：



```shell
# 之前已经知道了 mysql 容器的 id值，使用 a936即可标识该容器

# 那么可以使用下面的命令关闭容器
docker container stop a936

# 当然使用 mysql来标识该容器也是可以的
docker container stop mysql

# 使用ps检查该容器
docker ps -a
# 或 
docker container ls -a

# 处于终止的容器还可使用下面的命令重新启动
docker container start mysql
```

**删除一个处于终止状态的容器：**
 运行上面的容器仅仅是为了演示，所以我们将其删除，将在下文讲解如何真正运行该数据库容器。



```undefined
docker container rm a936
```

**存在的三个问题：**

- 数据保存的路径在哪？
- 如何编辑mysql的配置文件？比如需要修改字符集为utf8
- 如何查看日志文件

当实际使用时还需要考虑，在该容器中mysql的各种文件存放的位置在哪里，只有知道了相关目录那么我们就可以通过使用 `-v`挂载主机中的目录来替换容器中的目录：

相关文件的路径可以通过查看mysql映像本身内的相关文件(比如看看Dockerfile中)和目录以获取更多详细信息。

查看该镜像的Dockerfile文件或[library/mysql](https://hub.docker.com/_/mysql/)中的说明可知：

- 数据目录位于 `/var/lib/mysql`；所以我们可以在`docker run` 命令中添加下面的选项来覆盖该目录：

  

  ```jsx
  -v G:/Docker/mysql/mysql5.5.60/date:/var/lib/mysql
  ```

  意为，将本机G盘下的 `G:/Docker/mysql/mysql5.5.60/date` 目录挂载到容器的`/var/lib/mysql`目录上 (挂载效果与Linux中的挂载一样)

- 默认配置文件目录位于 `/etc/mysql/my.cnf`对于该配置文件我们可以直接覆盖，如果在Dockerfile中还看到`!includedir /etc/mysql/conf.d/`,那么说明mysql会先加载 my.cnf 中的配置，再加载  conf.d 文件夹中配置文件的的配置，利用这一点我们可以保留 my.cnf 中的配置，而将自定义的配置文件放在 conf.d 目录下。

  所以我们可以在`docker run` 命令中添加下面的选项来覆盖该目录：

  

  ```jsx
  -v G:/Docker/mysql/mysql5.5.60/custom:/etc/mysql/conf.d
  ```

  那么我们可以在本机G盘的 `G:/Docker/mysql/mysql5.5.60/custom` 目录下创建一个名为`config-file.cnf`配置文件，mysql容器就会加载该配置文件。

> `config-file.cnf`文件内容：(为了设置服务端编码)
>
> 
>
> ```csharp
> [mysqld]
>   character_set_server=utf8
> ```

> 脱离配置文件，直接在命令中配置：
>
> 参考文档[library/mysql](https://hub.docker.com/_/mysql/)的 “Configuration without a `cnf` file” 部分

> 参考： [library/mysql - Docker Hub](https://hub.docker.com/r/library/mysql/) 下的 Using a custom MySQL configuration file
>
> mysql 镜像 的Dockerfile 文件也可以在上面链接中找到。

**实际的操作步骤：**

1. 在主机上先创建要用于挂载的目录。比如`G:/Docker/mysql/mysql5.5.60/date`
2. 在`Docker Setting > Shared Drives`  中选中 G 盘（之后会需要输入你的系统的管理员密码），这使得Docker能够使用你G盘。
3. 最后执行下面的命令（自行做一些相应的更改）

**启动一个 mysql 容器的最终命令：**



```shell
$ docker run --name mysql5.5 -v G:/Docker/mysql/mysql5.5.60/custom:/etc/mysql/conf.d -v G:/Docker/mysql/mysql5.5.60/date:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=密码 -d mysql:5.5.60
```

## 安装mysql 8

**先 pull 镜像：**



```undefined
docker pull mysql
```

**运行容器：**

创建保存数据和配置文件的**目录**，下面的命令中需要使用



```jsx
docker run --name mysql-latest -v G:/Docker/mysql/mysql-latest/custom:/etc/mysql/conf.d -v G:/Docker/mysql/mysql-latest/data:/var/lib/mysql -p 3307:3306 -e MYSQL_ROOT_PASSWORD=密码 -d mysql:latest
```

**注意：**先不要在你的配置文件`G:/Docker/mysql/mysql-latest/customconfig-file`中添加任何内容，测试容器能否正常运行。如果可以，再往配置文件中添加配置，这样可以方便排除错误；因为旧版的mysql配置不一定适用于新版的mysql。下面的错误的源头就是配置文件的问题（我也一直没有想到是它的问题）。

出现错误的配置文件内容：



```ini
[mysqld]
    character_set_server=utf8
    lower_case_table_names=1
```

其中就是： `lower_case_table_names=1` **导致了错误**，容器无法运行。

还有就是用于保存mysql数据的目录需为空目录。

> 可参考： [docker安装mysql遇到的问题 - CSDN博客](https://blog.csdn.net/zhaokejin521/article/details/80468908)
>
> **这里说了mysql 8 的各种问题的原由**： [MySQL 8.0.11的更新之路 - 为程序员服务](http://ju.outofmemory.cn/entry/351666)

### 错误1：无法远程连接数据库

> 当时我自己是可以进行远程连接，所以这里只作记录；奇怪的现象是居然提示 mysql.user 表不存在：
>
> 
>
> ```go
> mysql> select host,user,plugin,authentication_string from mysql.user;
> ERROR 1146 (42S02): Table 'mysql.user' doesn't exist
> ```

如果 mysql 服务器版本大于 8.0.4，那么默认使用 caching_sha2_password 授权插件，而不是 5.6 / 5.7 使用的 mysql_native_password 进行身份验证。

使用下面的方法更改root账户的远程登录验证插件为 mysql_native_password：



```csharp
alter user 'root'@'%' identified with mysql_native_password by 'youPassword';

flush privileges;
```

> 下面三篇文章中都牵涉到验证插件相关命令
>
> [Docker安装MySQL8](http://blog.51cto.com/aaronsa/2133984)
>
> [Docker安装mysql8 - CSDN博客](https://blog.csdn.net/qq_32867467/article/details/80692441)
>
> [docker mysql 8.0](http://www.bubuko.com/infodetail-2570772.html)

### 错误2：No data dictionary version number found

最开始只关注到了与其一同出现的警告而忽略了警告下面的这个错误，当时的log是：

**警告1：Disabling symbolic links using --skip-symbolic-links (or equivalent) is the default.**



```shel
λ .\docker-run-mysql-latest.bat;

docker run --name mysql-latest -v G:\Docker\mysql\mysql-latest\custom:/etc/mysql/conf.d -v G:/Docker/mysql/mysql-latest/date:/var/lib/mysql -p 3307:3306 -e MYSQL_ROOT_PASSWORD=fan123  mysql:latest

2018-06-30T08:12:14.289452Z 0 [Warning] [MY-011070] [Server] 'Disabling symbolic links using --skip-symbolic-links (or equivalent) is the default. Consider not using this option as it' is deprecated and will be removed in a future release.

[翻译]使用--skip-symbolic-links（或等效）禁用符号链接是默认设置。考虑不使用此选项，因为它已被弃用，并将在未来版本中删除。

2018-06-30T08:12:14.289643Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.11) starting as process 1 
mbind: Operation not permitted
mbind：不允许操作
mbind: Operation not permitted

# 搞错了目标，上面只是 Warning ；而下面才是ERROR，导致退出的真正原因
2018-06-30T08:12:15.310586Z 1 [ERROR] [MY-011096] [Server] No data dictionary version number found.
2018-06-30T08:12:15.311077Z 0 [ERROR] [MY-010020] [Server] Data Dictionary initialization failed.
2018-06-30T08:12:15.311107Z 0 [ERROR] [MY-010119] [Server] Aborting
2018-06-30T08:12:16.560222Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.11)  MySQL Community Server - GPL.
```

真正的问题是 **错误1：No data dictionary version number found**

**一切错误的原因** 是我直接复制了 mysql 5.5的配置文件，导致一系列问题，也就是前文我说的配置文件相关的问题。

解决办法见上文。

> 错误原因见： [MySQL 8.0.11 报错 Different lower_case_table_names settings for server ('1') - CSDN博客](https://blog.csdn.net/vkingnew/article/details/80613043)
>
> 背景知识：
>
> MySQL8.0  新增了data dictionary的概念，数据初始化的时候在linux下默认使用`lower-case-table-names=0`的参数，数据库启动的时候读取的 my.cnf 文件中的值。若二者值不一致则在mysql的错误日志中记录报错信息。
>
> 在MySQL 5.7之前则允许数据库初始化和启动的值不一致且以启动值为准。
>  在MySQL 官方提供的RPM包中默认是使用 `lower-case-table-names=0`，不太适合生产环境部署。在生产环境建议使用官方的二进制包。
>
> 官方解释：
>
> After initialization, is is not allowed to change this setting.So "lower_case_table_names" needs to be set together with --initialize .
>
> 解决办法：
>
> 在mysql数据库初始化的时候指定不区分大小写，在数据库实例启动的时候也要指定不区分大小写。即数据库初始化时`lower_case_table_names`的值和数据库启动时的值需要一样。
>
> 在实际开发生产的应用中多是不区分大小写的即`lower-case-table-names=1`。
>
> 操作步骤：
>
> 
>
> ```ruby
>  /usr/local/mysql/bin/mysqld --user=mysql --lower-case-table-names=1 --initialize-insecure --basedir=/usr/local/mysql --datadir=/data/mysql/node1
> ```
>
> my.cnf
>
> 
>
> ```csharp
>  [mysqld]
>  lower_case_table_names = 1
> ```
>
> 若初始化和启动值不一样则会在错误日志中有如下提示：
>
> 
>
> ```kotlin
>  [ERROR] [MY-011087] [Server] Different lower_case_table_names settings for server ('1') and data dictionary ('0').
>  [ERROR] [MY-011087] [Server] Different lower_case_table_names settings for server ('0') and data dictionary ('1').
> ```
>
> 参考资料  https://bugs.mysql.com/bug.php?id=90695

> 2018.06，为什么mysql image 都提示有 " This image has vulnerabilities(漏洞) "？
>  标记为这类的镜像以为着有漏洞。这些漏洞通常来自他们所基于的系统或者上层镜像所带有的软件以及依赖库，当然也有可能就是软件本身的问题。 这个提示只是表示镜像所基于的环境是存在漏洞的，并不代表漏洞一定会被攻击。 你可以选择使用其Dockerflie重新构建镜像，对有漏洞的软件进行更新，也可以针对漏洞在防火墙层面进行防护。
>
> 不知道怎么解决。



作者：faner
链接：https://www.jianshu.com/p/d297b0be4157
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 其它

## [【MySQL】SQLSTATE详解](https://www.cnblogs.com/mqxs/p/6019992.html)