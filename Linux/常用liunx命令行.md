常用liunx命令行

Linux删除当前目录下的全部文件 10种方法

```
rm -rf *
```

linux建立文件夹软连接,并强制覆盖

 ````
ln -sfn /home/var/log/httpd/logs logs
ln -sfn /home/wqb/Work/Docker 

ln -sfn /home/lnmp/nginx/html/wordpress wordpress
 ````

这将在当前目录下建立logs软连接,指向/home/var/log/httpd/logs,如果存在logs软连接,将强制覆盖

linux删除目录很简单，很多人还是习惯用rmdir，不过一旦目录非空，就陷入深深的苦恼之中，现在使用rm -rf命令即可。
直接rm就可以了，不过要加两个参数-rf 即：rm -rf 目录名字
-r 就是向下递归，不管有多少级目录，一并删除
-f 就是直接强行删除，不作任何提示的意思

```
cat /proc/version
uname -r
uname -a
lsb_release -a
cat /etc/issue
Ubuntu 20.04 LTS
deb http://ppa.launchpad.net/rabbitvcs/ppa/ubuntu **20.04 LTS** main
```

```
sudo chmod 600 ××× （只有所有者有读和写的权限）
sudo chmod 644 ××× （所有者有读和写的权限，组用户只有读的权限）
sudo chmod 700 ××× （只有所有者有读和写以及执行的权限）
sudo chmod 666 ××× （每个人都有读和写的权限）
sudo chmod 777 ××× （每个人都有读和写以及执行的权限）

ｘｘｘ可以是文件名也可以是单个文件，中间加的　-R 是递归这个目录下的所有目录和文件

sudo code --user-data-dir="~/.vscode-root"
```

chmod +x navicat15-mysql-en.AppImage

./navicat15-mysql-en.AppImage



**Linux文件文件夹的压缩和解压**

**1.zip命令**

例如：**zip -r mysql.zip mysql** 该句命令的含义是：将mysql文件夹压缩成mysql.zip

**zip -r abcdef.zip abc def.txt** 这句命令的意思是将文件夹abc和文件def.txt压缩成一个压缩包abcdef.zip

**2.unzip命令**

与zip命令相反，这是解压命令，用起来很简单。 如：**unzip mysql.zip** 在当前目录下直接解压mysql.zip。

**3.tar命令**

例如：**tar -cvf 123.tar file1 file2 dir1** 该句命令实现一个tar压缩，它是将两个文件（file1和file2）和一个文件夹(dir1)压缩成一个123.tar文件。

**tar -zxvf apache-tomcat-7.0.75.tar.gz** 该命令在解压安装tomcat时使用，是将apache-tomcat.7.0.75.tar.gz直接解压到当前目录下。tar同时具有压缩的解压的功能，使用时根据参数和命令结构区分。

```
sudo tar -zxvf 
```

