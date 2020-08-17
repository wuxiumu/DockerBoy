### ## svn 安装

配置

svn://192.168.1.8/medical_equipment_management
账号：wuqingbao
密码：wuqingbao



 这些命令代表的功能是         

svn commit    提交更改项目
svn diff           显示变更项目
svn revert       还原/回滚变更操作
svn update     从SVN版本库获取更新
svn add          添加项目
svn rename    重命名SVN项目
svn log            显示日志文件
svn blame       项目变动追溯（这TM是谁写的……）
svn lock          锁定项目（一般是某些文件）
svn unlock      解除锁定 



# [Linux下常用svn命令](https://www.cnblogs.com/jaspersong/p/9277720.html)

# 参考资料：

1、 http://os.51cto.com/art/200908/143157_all.htm
2、 https://www.jianshu.com/p/d3ebfa27b3ba
3、 https://www.kancloud.cn/i281151/svn/197112

# 背景

版本控制工具svn之前一直用的是客户端，Linux下命令下没用过，最近因为项目的一些特性，版本控制需要在Linux进行操作。这里整合一下svn的常用命令。主要是参考网上的资料。

# 常用命令

## 1、svn checkout path

path 是服务器上的目录。

```
svn checkout path
例如：svn checkout  svn://192.168.1.1/pro/domain
简写：svn co
```

## 1.1 svn checkout path subv

这样将把你的工作拷贝放到subv而不是和前面那样放到trunk

## 2、svn add file

file是某个文件或者某个目录，如果添加所有的文件则用点“.”表示。

```
svn add file
例如：svn add test.php
svn  add  *.php（添加当前目录下所有的php文件）
svn add . （表示添加所有文件）
```

## 3、svn commit

提交文件到服务器。

```
svn commit -m “LogMessage“ [-N] [--no-unlock] path（如果选择了保持锁，就使用–no-unlock开关）
例如：svn commit -m “add test file for my test”  test.php
简写：svn  ci
```

一般步骤：

- step-1：`svn update`
- step-2：`svn add file、svn delete file`
- step-3：`svn commit -m “提交文件到远程服务器”`

## 4、svn lock

加锁/解锁命令。

```
svn lock -m “LockMessage” [--force] path
例如：svn lock -m “lock test file”  test.php
svn unlock path
```

## 5、svn update

更新版本命令。

```
svn update -r m path
例如：
1、	svn update 后面没有目录，默认更新当前目录及子目录的所有文件到最新版本。
2、	svn update -r 200 test.php （将版本库中的文件test.php还原到版本200）
简写：svn up
```

update命令还可以进行文件恢复。
（1）不小心写错了很多东西，想撤销所写的东西（已经把修改提交到服务器）` svn update -r 版本号`
（2）不小心删错了文件，想把文件恢复回来（已经把删除提交到服务器） `svn update -r 版本号`

## 6、svn status

```
svn status -v path
svn status path
简写：svn st
```

显示文件和子目录的状态。
第一列保持相同，第二列显示工作版本号，第三和第四列显示最后一次修改的版本号和修改人。
注：`svn status`、`svn diff`和 `svn revert`这三条命令在没有网络的情况下也可以执行的，原因是svn在本地的.svn中保留了本地版本的原始拷贝。

文件状态描述

- A 被添加到本地代码仓库
- ' ' 没有修改
- C 冲突
- D 被删除
- I 被忽略
- M 被修改
- R 被替换
- X 外部定义创建的版本目录
- ? 文件没有被添加到本地版本库内
- !文件丢失或者不完整（不是通过svn命令删除的文件）
- ~ 受控文件被其他文件阻隔

## 7、svn delete

删除文件。

```
svn delete path -m “delete test file”
例如：
1、删除远程服务器文件
svn delete svn://192.168.1.1/pro/domain/test.php  -m “delete test file”
2、删除本地文件，然后提交
svn  delete test.php， 然后再svn ci -m “delete test file”，推荐使用这种
简写：svn (del, remove, rm)
```

## 8、svn log

查看日志。

```
svn log path
例如：svn log test.php 显示这个文件的所有修改记录，及其版本号的变化。
```

如果在工程的根目录使用该命令可能会列出非常多的日志内容，因此为了查找方便，我们通常会使用一些附加参数来配合svn log命令的使用。

### **查看一段日期的日志**

```
svn log -r {2018-07-03}:{2018-07-09}
```

### **显示某一版本范围的log列表**

显示从r199687到r199385范围的所有带jaspersong字符串的log (grep下面介绍）

```
svn log -r r103546:r104414 | grep -A 2 jaspersong
```

这里说明一下`grep -A 2 "jasper"`|中A后面数字的差别，不同的数字表示显示的log版本信息不同的行数。

### **查看某一版本所修改的文件列表及说明**

此命名用得比较多。

```
svn log -r r196674 -v
```

![img](https://images2018.cnblogs.com/blog/668985/201807/668985-20180709111927602-1332322536.png)

### **查找分支所有的修改**

```
svn log -v --stop-on-copy $URL
```

## 9、svn info path

查看文件详细信息。

```
例如：svn info test.php
```

## 10、svn diff path

默认将修改的文件与基础版本比较。

```
例如：svn diff test.php
svn diff -r m:n path(对版本m和版本n比较差异)
例如：svn diff -r 200:201 test.php
简写：svn di
```

## 11、svn merge -r m:n path

Linux命令行下将两个版本之间的差异合并到当前文件。

```
svn merge -r m:n path
例如：svn merge -r 200:205 test.php（将版本200与205之间的差异合并到当前文件，但是一般都会产生冲突，需要处理一下。
```

## 12、svn help

Linux命令行下SVN 帮助。

```
svn help ci
```

# 不是常用的命令如下：

## 13、svn list path

显示path目录下的所有属于版本库的文件和目录。

```
简写：svn ls
```

## 14、svn revert path

下面两种情况都可以用revert命令恢复。

- **（1）不小心写错了很多东西，想撤销所写的东西（还未把修改提交到服务器）**
- **（2）不小心删错了文件，想把文件恢复回来（还未把删除提交到服务器）**
  注意: 本子命令不会存取网络，并且会解除冲突的状况。但是它不会恢复被删除的目录。【还不没实践过，不知道不会恢复本地删除的目录是什么意思】

## 15、svn resolved path

移除工作副本的目录或文件的“冲突”状态。

```
用法: svn resolved path
```

注意: **【本子命令不会依语法来解决冲突或是移除冲突标记；它只是移除冲突的相关文件，然后让 path 可以再次提交。】**

## 16、svn copy创建分支

- 创建分支参考资料：
  https://www.cnblogs.com/huang0925/p/3254243.html
  https://blog.csdn.net/yangzhongxuan/article/details/7519948
  https://blog.csdn.net/min954584739/article/details/78114273
- 从主干上创建分支。

```
svn cp -m "create branch"  http://svn_server/xxx_repository/trunk  http://svn_server/xxx_repository/branches/br_feature001 
```

- 获得分支

```
svn co http://svn_server/xxx_repository/branches/br_feature001
```

- 主干合并到分支

```
cd br_feature001 

svn merge http://svn_server/xxx_repository/trunk
```

- 分支合并到主干
  一旦分支上的开发结束，分支上的代码需要合并到主干。SVN中执行该操作需要在trunk的工作目录下进行。命令如下：

```
cd trunk 
svn merge --reintegrate http://svn_server/xxx_repository/branches/br_feature001 
```

## 17、分支合并到主干一

- 创建分支

```
svn copy http://example.com/repos/project/trunk http://example.com/repos/project/branches/beta
```

- 合并分支到主干
  在分支上，获取刚开始的版本号

```
svn log --stop-on-copy  http://example.com/repos/project/branches/search_collect_1108
```

如得到版本号为：12461

在分支上，获取最新的版本号

```
svn up
```

如得到版本号为：12767

切换到主干，然后执行下面命令**（后面的路径为，分支的路径。）**

```
svn merge -r 12461:12767  http://example.com/repos/project/branches/search_collect_1108
```

## 18、合并一个分支到主干二

- 查找到分支版本
  方法一：进入分支目录

```
cd branch 
svn log --stop-on-copy 
```

最后一个r11340就是创建分支时的reversion

方法二： 进入主干目录

```
cd trunk
svn -q --stop-on-copy 分支URL  # 这条命令会查询出自创建分支以后分支上的所有修改，最下面的那个版本号就是我们要找的版本号. 
示例：svn log -q --stop-on-copy svn://192.168.1.177/tags/beta_2009_12_24 
```

- 合并到主干
  **命令：svn -r 分支版本号:HEAD 分支的URL **
  **解释：HEAD为当前主干上的最新版本 **

```
示例： 
cd trunk 
svn merge -r 12:HEAD svn://192.168.1.177/tags/beta_2009_12_24 
```

解决冲突：
使用svn st | grep ^C 查找合并时的冲突文件，手工解决冲突
使用svn resolved filename 告知svn冲突已解决
使用svn commit -m "" 提示合并后的版本

update

clear up work copy

remove un file