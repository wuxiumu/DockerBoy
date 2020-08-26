#### 第一步： 安装 Git

 

NOTE：

接下来的操作都是在 Server 机器上运行

 

   Fedora 下运行：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. yum install git-core 

 

   Ubuntu 下运行：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. apt-get install git-core 

 

 

#### 第二步： 初始化一个 repository

 

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao myclone]$ cd /home/lgao/sources/my_own/repositories/ 
2. [lgao@lgao repositories]$ git init --bare myprj 
3. Initialized empty Git repository in /home/lgao/sources/my_own/repositories/myprj/.git/ 

 

  指定 --bare，当前 repository 下就只有 .git/ 下的 objects，而没有真实文件。一般在 Server 端。

 

#### 第三步： 初始化提交

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao myclient]$ mkdir initial.commit 
2. [lgao@lgao myclient]$ cd initial.commit/ 
3. [lgao@lgao initial.commit]$ git init 
4. Initialized empty Git repository in /home/lgao/sources/my_own/myclient/initial.commit/.git/ 
5. [lgao@lgao initial.commit]$ git remote add origin /home/lgao/sources/my_own/repositories/myprj/ 
6. [lgao@lgao initial.commit]$ touch Readme 
7. [lgao@lgao initial.commit]$ git add Readme 
8. [lgao@lgao initial.commit]$ git commit -m "initial commit" 
9. [master (root-commit) 032dad8] initial commit 
10.  0 files changed, 0 insertions(+), 0 deletions(-) 
11.  create mode 100644 Readme 
12. [lgao@lgao initial.commit]$ git push origin master 
13. Counting objects: 3, done. 
14. Writing objects: 100% (3/3), 206 bytes, done. 
15. Total 3 (delta 0), reused 0 (delta 0) 
16. Unpacking objects: 100% (3/3), done. 
17. To /home/lgao/sources/my_own/repositories/myprj/ 
18.  \* [new branch]   master -> master 

####  第四步 正常使用

 

   经过初始化提交过程，相当于激活了该 repository, 我们可以正常使用了。

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao myclient]$ git clone /home/lgao/sources/my_own/repositories/myprj/  
2. Cloning into 'myprj'... 
3. done. 
4. [lgao@lgao myclient]$ cd myprj 
5. [lgao@lgao myprj]$ l 
6. total 0 
7. -rw-rw-r-- 1 lgao lgao 0 Jan 21 15:15 Readme 
8. [lgao@lgao myprj]$ vim Readme  
9. [lgao@lgao myprj]$ git commit -m "modify readme" Readme 
10. [master 1bf69b4] modify readme 
11.  1 files changed, 1 insertions(+), 0 deletions(-) 
12. [lgao@lgao myprj]$ git push 
13. Counting objects: 5, done. 
14. Writing objects: 100% (3/3), 247 bytes, done. 
15. Total 3 (delta 0), reused 0 (delta 0) 
16. Unpacking objects: 100% (3/3), done. 
17. To /home/lgao/sources/my_own/repositories/myprj/ 
18.   032dad8..1bf69b4 master -> master 

 

 

####  第五步  与他人共享 Repository

 

​    按照上面的步骤，我们已经可以使用 Git 了。 但是 Git repository 的 URL 都是本地目录， 怎么能方便的让合作伙伴方便的访问该 Repository 呢？ 这就要介绍下 Git 支持的 4 中传输协议了： Local， SSH， Git， HTTP。 我们一个个的介绍：

##### Local

 Local 就是指本地文件系统，可以是本机器文件，也可以是通过 NFS 加载的网络映射。这种情形下与人共享就是把你的 repository 所在的目录作为 NFS 共享出去，让能访问到你机器的人像本地文件一样操作。具体怎么 NFS 共享超出本文范围，不加讨论（有兴趣的请参考： http://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/ch-nfs.html ）。不过不推荐这种方式共享， 因为效率太低。

##### SSH

  SSH 协议大家都很熟悉，只要你的 Server 能 ssh 登录就可以。假设你的 Server 可以远程 ssh 登录，我们看如何从 Server clone 出 Git Repository：

> Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)
>
> 1. [lgao@lgao myclient]$ git clone lgao@10.66.14.143:git_repos/myprj from_remote 
> 2. Cloning into 'from_remote'... 
> 3. lgao@10.66.14.143's password:  
> 4. remote: Counting objects: 3, done. 
> 5. remote: Total 3 (delta 0), reused 0 (delta 0) 
> 6. Receiving objects: 100% (3/3), done. 

>  也就是说只要你在 Server 端给一个用户创建完帐号后， 他就可以 clone 代码了。 具体的权限设置和 Linux 下权限配置是一样的。 一般跟一组 repositories 指定一个新的 group， 把新建的用户加入到该 group 后就可以有相应的读写权限了。

>   还有另外一种方式，是通过提交公钥到 Server 端来获得访问和提交权限，而不需要创建用户。 具体细节本文不加讨论。

##### Git

  该协议一般只是只读权限。

 

  第一步需要安装 git-daemon：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [root@lgao ~]# yum install git-daemon 

 

  接着启动 git-daemon：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao initial.commit]$ git daemon --base-path=/home/lgao/sources/my_own/repositories --export-all 

 

  在你的工程下创建 **git-daemon-export-ok 文件：**

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao repositories]$ cd myprj 
2. [lgao@lgao myprj]$ touch git-daemon-export-ok 

 

   现在就可以通过 Git 协议 clone repository 了：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao test]$ git clone git://lgao.nay.redhat.com/myprj 
2. Cloning into 'myprj'... 
3. remote: Counting objects: 6, done. 
4. remote: Compressing objects: 100% (2/2), done. 
5. remote: Total 6 (delta 0), reused 0 (delta 0) 
6. Receiving objects: 100% (6/6), done. 

##### HTTP

  该协议一般只是只读权限。GitWeb 包提供 CGI ， 它可以被部署到任何支持静态 web 服务的服务器中去。我们还以最常见的 Apache 为例：

 

  版本信息：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. Httpd：Apache/2.2.21 (Fedora)  
2. Git： git version 1.7.7.5 
3. GitWeb：1.7.7.5-1.fc16 

 

  安装 Httpd 和 gitweb：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao initial.commit]$ sudo yum install httpd gitweb 

 

  修改 /etc/gitweb.conf：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [lgao@lgao repositories]$ vim /etc/gitweb.conf 
2. 修改： 
3. our $projectroot = "/home/lgao/sources/my_own/repositories";  

 

  在 httpd 的 DocumentRoot 所在目录创建 Link 文件：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [root@lgao DCIM]# cd /var/www/html 
2. [root@lgao html]# ln -s /home/lgao/sources/my_own/repositories/ git 
3. [root@lgao html]# chown -R lgao.lgao git 

 

  修改 httpd.conf 中的 user 和 group：

Java代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. User lgao 
2. Group lgao 

 

  重启 httpd：

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [root@lgao httpd]# service httpd restart 
2. Restarting httpd (via systemctl):             [ OK ] 

 

  OK 了， 现在就可以访问了：

![点击查看原始大小图片](http://dl.iteye.com/upload/attachment/0062/3561/18066ccb-428b-397a-bd52-293e47af595b.png)

 

  你可以修改 Server 机器下 <Your Repo>/description ，这样可以显示在 git web 页面上。

 

  修改 <Your Repo>/config ， 加上 owner 和 url：

 

 

Shell代码 ![收藏代码](http://aoingl.iteye.com/images/icon_star.png)

1. [gitweb] 
2. ​    owner = Your Name <name@example.com> 
3. ​    url = git://lgao.nay.redhat.com/myprj 

 

 

之后，我们再看看截图：

 ![点击查看原始大小图片](http://dl.iteye.com/upload/attachment/0062/3569/fd8a40bc-aac7-3a54-9d08-148075bc976e.png)

 

 

二 git常用命令

git clone: 这是较为简单的一种初始化方式，当你已经有一个远程的Git版本库，只需要在本地克隆一份，例如'git clone git://github.com/someone/some_project.git some_project'命令就是将'git://github.com/someone/some_project.git'这个URL地址的远程版 本库完全克隆到本地some_project目录下面

git init和git remote：这种方式稍微复杂一些，当你本地创建了一个工作目录，你可以进入这个目录，使用'git init'命令进行初始化，Git以后就会对该目录下的文件进行版本控制，这时候如果你需要将它放到远程服务器上，可以在远程服务器上创建一个目录，并把 可访问的URL记录下来，此时你就可以利用'git remote add'命令来增加一个远程服务器端，例如'git remote add origin git://github.com/someone/another_project.git'这条命令就会增加URL地址为'git: //github.com/someone/another_project.git'，名称为origin的远程服务器，以后提交代码的时候只需要使用 originalias.html' target='_blank'>别名即可

现在我们有了本地和远程的版本库，让我们来试着用用Git的基本命令吧：

git pull：从其他的版本库（既可以是远程的也可以是本地的）将代码更新到本地，例如：'git pull origin master'就是将origin这个版本库的代码更新到本地的master主枝，该功能类似于SVN的update

git add：是将当前更改或者新增的文件加入到Git的索引中，加入到Git的索引中就表示记入了版本历史中，这也是提交之前所需要执行的一步，例如'git add app/model/user.rb'就会增加app/model/user.rb文件到Git的索引中

git rm：从当前的工作空间中和索引中删除文件，例如'git rm app/model/user.rb'

git commit：提交当前工作空间的修改内容，类似于SVN的commit命令，例如'git commit -m story #3, add user model'，提交的时候必须用-m来输入一条提交信息

git push：将本地commit的代码更新到远程版本库中，例如'git push origin'就会将本地的代码更新到名为orgin的远程版本库中

git log：查看历史日志

git revert：还原一个版本的修改，必须提供一个具体的Git版本号，例如'git revert bbaf6fb5060b4875b18ff9ff637ce118256d6f20'，Git的版本号都是生成的一个哈希值

上面的命令几乎都是每个版本控制工具所公有的，下面就开始尝试一下Git独有的一些命令：

git branch：对分支的增、删、查等操作，例如'git branch new_branch'会从当前的工作版本创建一个叫做new_branch的新分支，'git branch -D new_branch'就会强制删除叫做new_branch的分支，'git branch'就会列出本地所有的分支

git checkout：Git的checkout有两个作用，其一是在不同的branch之间进行切换，例如'git checkout new_branch'就会切换到new_branch的分支上去；另一个功能是还原代码的作用，例如'git checkout app/model/user.rb'就会将user.rb文件从上一个已提交的版本中更新回来，未提交的内容全部会回滚

git rebase：用下面两幅图解释会比较清楚一些，rebase命令执行后，实际上是将分支点从C移到了G，这样分支也就具有了从C到G的功能

git stash：将当前未提交的工作存入Git工作栈中，时机成熟的时候再应用回来，这里暂时提一下这个命令的用法，后面在技巧篇会重点讲解

git config：利用这个命令可以新增、更改Git的各种设置，例如'git config branch.master.remote origin'就将master的远程版本库设置为别名叫做origin版本库，后面在技巧篇会利用这个命令个性化设置你的Git，为你打造独一无二的 Git

git tag：可以将某个具体的版本打上一个标签，这样你就不需要记忆复杂的版本号哈希值了，例如你可以使用'git tag revert_version bbaf6fb5060b4875b18ff9ff637ce118256d6f20'来标记这个被你还原的版本，那么以后你想查看该版本时，就可以使用 revert_version标签名，而不是哈希值了

## 使用Gitolite来对Git的repository实现权限控制

我们项目组打算从svn向git迁移，前几天我搭建了git环境，把代码从svn转移过来，然后所有成员都通过server上的git账号来做pull和push，一切都安置妥当，没有问题。但是后来其它项目组也打算使用这个git server，那么问题来了，之前那种授权的方式肯定是不够的，因为只要能连上server，那么他对这个server上所有的repository都有完全的读写权限，这显然是不可接受的。

所以打算使用Gitolite这个组件来做权限控制，搜索了下，找到的文章貌似都是老版本的，所以有了写这篇文章的想法。

Gitolite其实也是一个git repository，首先在server上安装好后，在client上把server上的repository clone下来，在本地做一些更改，再push回server，server端的hooks会根据push上来的配置来更新权限。

接下来，介绍下安装和配置步骤

### 准备工作

如果你之前是用git账号来做权限控制的话，记得把`/etc/passwd`里git用户的shell换回`/bin/bash`，然后把`~git/.ssh/authorized_key`里不再需要的key移除。

用`ssh-kengen`生成一对key，比如your-name和your-name.pub（下文均以此为例）

拷贝私钥到本用户的.ssh文件夹中

```text
mv your-name ~/.ssh/
```

拷贝公钥到git server上

```text
scp you-name.pub git@your.server.name.or.ip.address:~
```

为了以后方便，这里可以做一个server别名，指定连接所需的用户名，server的地址、端口以及私钥

```text
vim ~/.ssh/config
```

输入以下内容

```text
host githost
user your-name
hostname your.server.name.or.ip.address
port 22
identityfile ~/.ssh/your-name
```

### 安装Gitolite

登录git server

```text
ssh git@your.server.name.or.ip.address
```

下载最新的Gitolite

```text
git clone git://github.com/sitaramc/gitolite
```

安装，这里说明下，安装方式有3种，区别在与指定生成`gitolite`可执行文件的路径，这里采用Gitolite作者推荐的第二种，也就是把文件生成到`$HOME/bin`中，这样可以在接下来的bash中直接执行`gitolite`命令而不用指定路径(如果你的`~/bin`目录不存在记得先`mkdir ~/bin`)

```text
gitolite/install -ln
```

设置，由于是第一次运行这个命令，所以这里指定的key是拥有Gitolite管理员权限的

```text
gitolite setup -pk your-name.pub
```

此命令会在你的`~/repositories/`目录生成两个repository：gitolite-admin.git和testing.git

### 配置权限

退到你的workstation上

```text
exit
```

clone刚才生成的gitolite-admin.git

```text
git clone githost:gitolite-admin
```

注意这里用的是刚才准备好的server别名来连接的，其中最重要的区别是使用your-name.pub这个key，并且没有采用绝对路径来指定想要clone的repository，而是直接使用名称，并且这个名称也没有包括.git这个后缀。这一点很重要，因为这是用Gitolite的机制来clone，如果你跳过它直接使用git来，那么它的一些功能就无法实现了。以后clone, push其它需要受Gitolite权限控制的repository都必须这样做。

clone完后会有个新的目录`gitolite-admin`，里面有两个文件夹`conf`和`keydir`，第一个目录中包含的是配置文件，里面就是记录权限配置的地方，第二个目录中则包含所有用户的pub key。

现在我们打开配置文件，按照我们的权限配置需要进行设置

```text
vim gitolite-admin/conf/gitolite.conf
```

我期望的配置如下，你也可以根据你的需要做更改

```text
@repos_a @proj1 @proj2
@repos_b @proj3 @proj4 @proj5

@team_a @user1 @user2
@team_b @user3 @user4

repo gitolite-admin
RW+ = your-name

repo @repos_a
RW+ = @team_a
R = @all

repo @repos_b
RW+ = @team_b
```

这个配置很简单，首先定义了两个repository group，再又定义了两个user group，group的好处就是以后添加repository和user的时候，不需要再单独配置，只需加入到对应的group中即可。

- 添加全新的repository，在上面提到的gitolite.conf文件中配置好对应的名称和权限，再push到server即可，server会自动帮你创建一个empty的bare repository。
- 如果你已经有一个repository，想把它加进来的话，那就把它拷贝到git server上的`~/repositories`文件夹里，记得文件夹名要以.git结尾，并且这个repository一定要是bare的，（你可以通过拷贝repository里的.git文件夹，然后运行`git config --bool core.bare true`，也可以运行`git clone --bare your-repository`来得到bare repository）。这种方式还有一个额外的操作就是在server上运行一次`gitolite setup`。
- 移除repository，在配置文件中移除对应的repo，然后push，接着再删除server上对应的文件夹即可。
- 添加user，把pub key拷贝到`keydir`文件夹里
- 删除user，一样，移除`keydir`里对应的pub key

注意，上面说的操作，都必须在clone的gitolite-admin里做更改，然后push，千万别在server上自己来，那样是没用的，因为这些权限配置、repository管理都有一些额外的操作，gitolite-admin会帮你搞定一切。

把你的更改push回server上，试试clone，pull，push，看看权限是否正确。比如

```text
git clone githost:proj3
```

git remote add origin /home/lgao/sources/my_own/repositories/myprj/

git remote add origin /home/git/myprj/

/home/git/myprj/





 git clone /home/git/myprj/

 git clone git@10.66.14.143:git_repos/myprj from_remote



 git daemon --base-path=/home/git/myprj/ --export-all



 git clone git://api.nbdon.com/myprj 



http://

```
git clone git@116.196.115.98:/data/wwwroot/api.nbdon.com/myprj
```



