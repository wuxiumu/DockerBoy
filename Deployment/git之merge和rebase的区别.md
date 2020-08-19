uchuangao 2017-10-27 [原文](https://www.bbsmax.com/link/YW1kMDREYTZkZw==)

#### merge合并

```
# merge操作 第一步：
# 先创建一个目录，在主分支提交3个txt文件
[root@luchuangao]# mkdir oldboy
[root@luchuangao]# git init 初始化
[root@luchuangao]# echo "a" > a.txt
[root@luchuangao]# echo "b" > b.txt
[root@luchuangao]# echo "c" > c.txt
[root@luchuangao]# git add a.txt
[root@luchuangao]# git commit -m 'a'
[master（根提交） ac03ef7] a
 1 file changed, 1 insertion(+)
 create mode 100644 a.txt
[root@luchuangao]# git add b.txt
[root@luchuangao]# git commit -m 'b'
[master 65c273b] b
 1 file changed, 1 insertion(+)
 create mode 100644 b.txt
[root@luchuangao]# git add c.txt
[root@luchuangao]# git commit -m 'c'
[master ddb2007] c
 1 file changed, 1 insertion(+)
 create mode 100644 c.txt 第二步：
# 创建并切换到testing分支，并提交2个txt文件
[root@luchuangao]# git checkout -b testing
切换到一个新分支 'testing'
[root@luchuangao]# echo "test1" > test1.txt
[root@luchuangao]# echo "test2" > test2.txt
[root@luchuangao]# git add test1.txt
[root@luchuangao]# git commit -m 'test1'
[testing 4d18278] test1
 1 file changed, 1 insertion(+)
 create mode 100644 test1.txt
[root@luchuangao]# git add test2.txt
[root@luchuangao]# git commit -m 'test2'
[testing 2c7ef37] test2
 1 file changed, 1 insertion(+)
 create mode 100644 test2.txt # 查看testing分支日志
 [root@proxy-nfs oldboy]# git log
commit 2c7ef374134f0158fab77137717d7ba1c1281a36
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:42:26 2017 +0800     test2 commit 4d182786a2199f10351dd69e819d6878513c8456
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:42:17 2017 +0800     test1 commit ddb20076027cca6b310a30468445ce82e96dcbcd
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:41:13 2017 +0800     c commit 65c273b1512cbad0c4325d21f1cd6c421d14f2b3
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:41:07 2017 +0800     b commit ac03ef772d4e01914d0917676d2f33eca8c0bb11
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:40:57 2017 +0800     a 第三步：
# 切换至主分支，再在主分支提交2个txt文件
[root@proxy-nfs oldboy]# git checkout master
切换到分支 'master'
[root@proxy-nfs oldboy]# echo "master1" > master1.txt
[root@proxy-nfs oldboy]# echo "master2" > master2.txt
[root@proxy-nfs oldboy]# git add master1.txt
[root@proxy-nfs oldboy]# git commit -m 'master1'
[master 9353089] master1
 1 file changed, 1 insertion(+)
 create mode 100644 master1.txt
[root@proxy-nfs oldboy]# git add master2.txt
[root@proxy-nfs oldboy]# git commit -m 'master2'
[master 1cca7b6] master2
 1 file changed, 1 insertion(+)
 create mode 100644 master2.txt # 查看master分支日志
[root@proxy-nfs oldboy]# git log
commit 1cca7b62bbb5b7f7e62a7d2c55a76618109bbffc
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:43:37 2017 +0800     master2 commit 9353089557089753359445242c32352fcb6b32f0
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:43:30 2017 +0800     master1 commit ddb20076027cca6b310a30468445ce82e96dcbcd
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:41:13 2017 +0800     c commit 65c273b1512cbad0c4325d21f1cd6c421d14f2b3
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:41:07 2017 +0800     b commit ac03ef772d4e01914d0917676d2f33eca8c0bb11
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:40:57 2017 +0800     a 第四步：
# 合并testing，不做修改，直接wq保存
[root@luchuangao oldboy]# git merge testing
Merge branch 'testing' # 请输入一个提交信息以解释此合并的必要性，尤其是将一个更新后的上游分支
# 合并到主题分支。
#
# 以 '#' 开头的行将被忽略，而且空提交说明将会终止提交。 ".git/MERGE_MSG" 6L, 238C written
Merge made by the 'recursive' strategy.
 test1.txt | 1 +
 test2.txt | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 test1.txt
 create mode 100644 test2.txt # 查看master分支日志，多了一个“Merge branch 'testing'” 日志记录
[root@luchuangao oldboy]# git log
commit ea4c21bd398bd1a766bc8a498df44c8e2dc4993e
Merge: 1cca7b6 2c7ef37
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:51:14 2017 +0800     Merge branch 'testing' commit 1cca7b62bbb5b7f7e62a7d2c55a76618109bbffc
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:43:37 2017 +0800     master2 commit 9353089557089753359445242c32352fcb6b32f0
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:43:30 2017 +0800     master1 commit 2c7ef374134f0158fab77137717d7ba1c1281a36
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:42:26 2017 +0800     test2 commit 4d182786a2199f10351dd69e819d6878513c8456
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:42:17 2017 +0800     test1 commit ddb20076027cca6b310a30468445ce82e96dcbcd
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:41:13 2017 +0800     c commit 65c273b1512cbad0c4325d21f1cd6c421d14f2b3
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:41:07 2017 +0800     b commit ac03ef772d4e01914d0917676d2f33eca8c0bb11
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:40:57 2017 +0800     a
[root@luchuangao oldboy]# 
```

#### rebase变基

```
# rebase操作 第一步：
# 先创建一个目录，在主分支提交3个txt文件
[root@luchuangao ~]# cd oldgirl/
[root@luchuangao oldgirl]# git init
初始化空的 Git 版本库于 /root/oldgirl/.git/
[root@luchuangao oldgirl]# echo "a" > a.txt
[root@luchuangao oldgirl]# echo "b" > b.txt
[root@luchuangao oldgirl]# echo "c" > c.txt
[root@luchuangao oldgirl]# git add a.txt
[root@luchuangao oldgirl]# git commit -m 'a'
[master（根提交） c54fa4b] a
 1 file changed, 1 insertion(+)
 create mode 100644 a.txt
[root@luchuangao oldgirl]# git add b.txt
[root@luchuangao oldgirl]# git commit -m 'b'
[master c889368] b
 1 file changed, 1 insertion(+)
 create mode 100644 b.txt
[root@luchuangao oldgirl]# git add c.txt
[root@luchuangao oldgirl]# git commit -m 'c'
[master 60fe420] c
 1 file changed, 1 insertion(+)
 create mode 100644 c.txt 第二步：
# 创建并切换到testing分支，并提交2个txt文件
 [root@luchuangao oldgirl]# git checkout -b testing
切换到一个新分支 'testing'
[root@luchuangao oldgirl]# echo "test1" > test1.txt
[root@luchuangao oldgirl]# echo "test2" > test2.txt
[root@luchuangao oldgirl]# git add test1.txt
[root@luchuangao oldgirl]# git commit -m 'test1'
[testing 65f10cf] test1
 1 file changed, 1 insertion(+)
 create mode 100644 test1.txt
 [root@luchuangao oldgirl]# git add test2.txt
[root@luchuangao oldgirl]# git commit -m 'test2'
[testing 747599f] test2
 1 file changed, 1 insertion(+)
 create mode 100644 test2.txt
[root@luchuangao oldgirl]# git log
commit 747599fba4c46673f8aae88828d2ac884e3cb2a4
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:56:21 2017 +0800     test2 commit 65f10cfc43af5d364a24907564e0eb0898edf2e1
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:56:00 2017 +0800     test1 commit 60fe4206ed68a3c7a0a2473310f9430e233ee1e9
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:21 2017 +0800     c commit c889368e57e171ca58dcfc98fa7d742fe22fa362
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:16 2017 +0800     b commit c54fa4bff7733175ef67b7db6b222464039aafb4
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:10 2017 +0800     a 第三步：
# 切换至主分支，再在主分支提交2个txt文件
[root@luchuangao oldgirl]# git checkout master
切换到分支 'master'
[root@luchuangao oldgirl]# echo "master1" > master1.txt
[root@luchuangao oldgirl]# echo "master2" > master2.txt
[root@luchuangao oldgirl]# git add master1.txt
[root@luchuangao oldgirl]# git commit -m 'master1'
[master ca28eb9] master1
 1 file changed, 1 insertion(+)
 create mode 100644 master1.txt
[root@luchuangao oldgirl]# git add master2.txt
[root@luchuangao oldgirl]# git commit -m 'master2'
[master a48b977] master2
 1 file changed, 1 insertion(+)
 create mode 100644 master2.txt
[root@luchuangao oldgirl]# git log
commit a48b977c1c0459066cf20bbd28d77021e85ab15c
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:57:25 2017 +0800     master2 commit ca28eb9251012b0501a2678e42e765dc5fb9b81c
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:57:20 2017 +0800     master1 commit 60fe4206ed68a3c7a0a2473310f9430e233ee1e9
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:21 2017 +0800     c commit c889368e57e171ca58dcfc98fa7d742fe22fa362
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:16 2017 +0800     b commit c54fa4bff7733175ef67b7db6b222464039aafb4
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:10 2017 +0800     a 第四步：
# 合并testing
[root@luchuangao oldgirl]# git rebase testing
首先，重置头指针以便在上面重放您的工作...
正应用：master1
正应用：master2 # 查看master分支日志，发现根本没有合并得日志记录
[root@luchuangao oldgirl]# git log
commit e28b92283b6dff9af42446183e121cc379f79e7b
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:57:25 2017 +0800     master2 commit 6e49a215c918e3e3ce229bf4aff1bb8608f03d4e
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:57:20 2017 +0800     master1 commit 747599fba4c46673f8aae88828d2ac884e3cb2a4
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:56:21 2017 +0800     test2 commit 65f10cfc43af5d364a24907564e0eb0898edf2e1
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:56:00 2017 +0800     test1 commit 60fe4206ed68a3c7a0a2473310f9430e233ee1e9
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:21 2017 +0800     c commit c889368e57e171ca58dcfc98fa7d742fe22fa362
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:16 2017 +0800     b commit c54fa4bff7733175ef67b7db6b222464039aafb4
Author: luchuangao <luchuangao@126.com>
Date:   Fri Oct 27 20:54:10 2017 +0800     a
```

#### merge与rebase的区别

由以上操作第四步，可以很明显看出，merge和rebase得区别。

merge有“Merge branch 'testing'”日志记录，而rebase木有。

merge 合并两个或更多开发历史。

rebase 本地提交转移至更新后的上游分支中。

**使用场景：**

merge可以保存历史记录，记录什么时间合并的，从哪个分支合并过来得，数据不会变动，即使删除testing分支，数据还是存在得。

rebase隐藏了提交细节，好像没开过分支一样。

## [git之merge和rebase的区别的更多相关文章](https://www.bbsmax.com/R/amd04Da6dg/)

1. Git分支merge和rebase的区别

   Git merge是用来合并两个分支的. git merge b # 将b分支合并到当前分支 同样 git rebase b,也是把 b分支合并到当前分支 原理 如下: 假设你现在基于远程分支&quo ...

2. [git]merge和rebase的区别

   前言 我从用git就一直用rebase,但是新的公司需要用merge命令,我不是很明白,所以查了一些资料,总结了下面的内容,如果有什么不妥的地方,还望指正,我一定虚心学习. merge和rebase ...

3. merge和rebase的区别

   前言 我从用git就一直用rebase,但是新的公司需要用merge命令,我不是很明白,所以查了一些资料,总结了下面的内容,如果有什么不妥的地方,还望指正,我一定虚心学习. merge和rebase ...

4. git——merge和rebase的区别

   参考http://www.jianshu.com/p/129e721adc6e 我在公司里看到其他同事都使用git pull --rebase拉取远程代码,而我总是用git pull,也有同事和我说过 ...

5. Git Step by Step – (8) Git的merge和rebase

   前面一篇文章中提到了"git pull"等价于"git fetch"加上"git merge",然后还提到了pull命令支持rebase模式 ...

6. [Git] git merge和rebase的区别

   git merge 会生成一个新得合并节点,而rebase不会 比如: D---E test / A---B---C---F master 使用merge合并, 为分支合并自动识别出最佳的同源合并点: ...

7. git merge 与 rebase 的区别

   http://gitbook.liuhui998.com/4_2.html merge rebase

8. 关于Git的merge和rebase命令解析

   git rebase是对提交执行变基的操作.即可以实现将指定范围的提交"嫁接"到另外一个提交智商. 其常用的命令格式有: 用法1:git rebase --onto <new ...

9. Merge和Rebase在Git中的区别

   git命令Merge和Rebase的区别 git merge 会生成一个新得合并节点,而rebase不会 比如: D---E test / A---B---C---F master 使用merge合并 ...

## 随机推荐

1. 迅雷9、迅雷极速版之迅雷P2P加速：流量吸血鬼？为什么你装了迅雷之后电脑会感觉很卡很卡？

   原文地址:http://www.whosmall.com/post/90 关闭极速版迅雷ThunderPlatform.exe进程 ThunderPlatform.exe目的:利用P2P技术进行用户间 ...

2. redmine问题集锦

   当我新建LDAP认证模式时,遇到如下错误:

3. Android观察者模式的简单实现demo

   观察者模式就是:当一个对象的状态发送改变时,所有依赖于它的对象都能得到通知并被自动更新. 下面介绍一种简单的使用方法,(下面有demo链接)先看一下project的目录构成: ObserverList ...

4. WCF报 当前已禁用此服务的元数据发布的错误

   这是 Windows© Communication Foundation 服务. 当前已禁用此服务的元数据发布. 如果具有该服务的访问权限,则可以通过完成下列步骤来修改 Web 或应用程序配置文件以便 ...

5. max plugin wizard，project creation faild解法

   两点需要注意: 1,要将maxsdk的3dsmaxPluginWizard文件夹设为只读. 2,要将3dsmaxPluginWizard.vsz中的"Wizard="设置为正确的v ...

6. 给Qt生成的exe执行程序添加版本信息

   Windows下的.exe可执行文件的属性中有版本这个信息,含有版本信息.描述.版权等.对于qt程序,要含有这样的信息,那就请如下操作:新建<工程名>.rc文件,在rc文件填入下的信息: ...

7. Eclipse导出jar包Unity打包错误

   前几天接SDK使用的是Android Studio昨天打开AndroidStudio后自动更新了gradler然后失败了然后AndroidStudio就挂了.就是用之前的方法Eclipse到处jar包 ...

8. typedef和define具体的具体差别

    1) #define是预处理指令,在编译预处理时进行简单的替换,不作正确性检查,不关含义是否正确照样带入,仅仅有在编译已被展开的源程序时才会发现可能的错误并报错.比如: #define PI 3. ...

9. We Chall-Training: LSB-Writeup

   MarkdownPad Document html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,ab ...

10. .NET C#到Java没那么难，Servlet篇

    前言 .NET C#到Java没那么难,都是面向对向的语言,而且语法还是相似的,先对比一下开发环境,再到Servlet,再到MVC,都是一样一样的,只是JAVA的配制项比较多而已,只要配好一个,后面都 ...