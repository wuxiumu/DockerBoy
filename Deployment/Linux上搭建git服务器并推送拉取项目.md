## 1、Linux上搭建git服务器

Crt中上传git源码
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228103810432.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2MjA1MjA2,size_16,color_FFFFFF,t_70)
用put命令+文件的全路径上传
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228103954877.png)

```
远程仓库实际上和本地仓库没啥不同，纯粹为了7x24小时开机并交换大家的修改。
GitHub就是一个免费托管开源代码的远程仓库。但是对于某些视源代码如生命的商业公司来说，
既不想公开源代码，又舍不得给GitHub交保护费，那就只能自己搭建一台Git服务器作为私有仓库使用。
搭建Git服务器需要准备一台运行Linux的机器，在此我们使用CentOS。以下为安装步骤：
1、安装git服务环境准备(在线安装、Linux服务器需要能上网)
yum -y install curl curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel gcc cc
2、下载git-2.5.0.tar.gz
1）解压缩
2）cd git-2.5.0
3）autoconf(执行该命令)
4）./configure(执行该命令)
5）make(执行该命令编译源码)
6）make install(执行该命令 将git安装到相应的目录)
完成之后执行git --version可以查看当前git版本。
3、添加用户
adduser -r -c 'git version control' -d /home/git -m git
此命令执行后会创建/home/git目录作为git用户的主目录。
5、设置密码
passwd git
输入两次密码
6、切换到git用户
su git
创建仓库文件夹repo1
1234567891011121314151617181920212223
```

解压缩
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104004936.png)

```
7、创建git仓库
git --bare init /home/git/first
注意：如果不使用“--bare”参数，初始化仓库后，提交master分支时报错。这是由于git
默认拒绝了push操作，需要.git/config添加如下代码：
[receive]
      denyCurrentBranch = ignore
推荐使用：git --bare init初始化仓库。
1234567
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020022713282589.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2MjA1MjA2,size_16,color_FFFFFF,t_70)
查看当前用户
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020022810402140.png)

## 2、将本地项目推送到远端服务器

```
私有git服务器搭建完成后就可以向连接github一样连接使用了，但是我们的git服务器并没有配置密钥登录，所以每次连接时需要输入密码。
使用命令连接：
$ git remote add origin ssh://git@192.168.25.156/home/git/first
这种形式和刚才使用的形式好像不一样，前面有ssh://前缀，好吧你也可以这样写：
$ git remote add origin git@192.168.25.156:first
12345
```

**TortoiseGit同步：**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104050855.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104056243.png)
添加一个远端：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104106600.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2MjA1MjA2,size_16,color_FFFFFF,t_70)
输入服务器的密码
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020022810411887.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2MjA1MjA2,size_16,color_FFFFFF,t_70)

## 3、从远端服务器仓库克隆项目到本地

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104309142.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104313561.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2MjA1MjA2,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200228104319476.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2MjA1MjA2,size_16,color_FFFFFF,t_70)