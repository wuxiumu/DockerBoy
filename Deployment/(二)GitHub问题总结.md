# Q1

【Problem】

```
# 请输入一个提交信息以解释此合并的必要性，尤其是将一个更新后的上游分支
# 合并到主题分支。
#
# 以 '#' 开头的行将被忽略，而且空提交说明将会终止提交。
1234
```

【Solve】
写入信息后,`Ubuntu`环境使用`ctrl+x`选择是否保存.

# Q2

【Problem】

```
To https://github.com/xindaqi/AIFuture.git
! [remote rejected] master -> master (pre-receive hook declined)
error: 无法推送一些引用到 'https://github.com/xindaqi/AIFuture.git'
123
```

【Solve】
清理工作区,重新pull,重新push.(无奈>_<)

# Q3 撤销commit

commit后但没有push。
【Solve】
(1) 查看日志:git log

```
commit 8ff71501be6e5860f3441b712ec6a9b04a69fd9a (HEAD -> master, matplot_test)
    add matplot test, draw different image
commit e7dea5372748d996e35862dfce0b4483a60fc55f (origin/master)
    add python library for xindaqi
1234
```

(2) 撤销`commit id`
日志`commit`后面的字符串为`id`.

```
git reset hard 8ff71501be6e5860f3441b712ec6a9b04a69fd9a
1
```

# Q4 重置Head

【Problem】
提交的commit不能撤销，头部指向该commit。

```
commit ************** (HEAD -> master)
Author: ****** <********>
Date:   Sun May 12 16:14:40 2019 +0800

    describe
12345
```

【Solve】

```
git commit -m "delete test"
git reset HEAD~
12
```

# Q5 冲突

## 5.1 提交代码出现冲突

- 场景
  远程仓库A，本地仓库B1，本地仓库B2
  B1本地仓库修改代码，同步到A，
  B2本地仓库提交更新至A，未合并（或拉取远程代码），出现冲突
- 提示信息
  CONFLICT (content): Merge conflict
- 方案

```
git mergetool
```

# Q6

```
git fetch
git pull
```

# Q7

```
git add 

The file will have its original line endings in your working directory
```

【Solve】

```
 git config --global core.autocrlf false
```

## 问题描述：

​     git add：添加至暂存区，但并未提交至服务器。git add . 是表示把当前目录下的所有更新添加至暂存区。有时在终端操作这个会提示：

```
warning: LF will be replaced by CRLF in ball_pool/assets/Main.js.The file will have its original line endings in your working directory
```

## 原因：

​     这是因为文件中换行符的差别导致的。这个提示的意思是说：会把windows格式（CRLF（也就是回车换行））转换成Unix格式（LF），这些是转换文件格式的警告，不影响使用。

git默认支持LF。windows commit代码时git会把CRLF转LF，update代码时LF换CRLF。

## 解决方法：

**注： . 为文件路径名**

```
git rm -r --cached .
git config core.autocrlf falsegit 
add .
git commit -m '' 
git push
```

```
git clone http://api.nbdon.com/api.nbdon.com.git

git remote add origin ssh://git@116.196.115.98:22/home/git/first

git remote add origin git@116.196.115.98:first

git remote add origin ssh://git@116.196.115.98:22/home/git/myprj
ssh://git@116.196.115.98:22/home/git/myprj

git clone ssh://git@116.196.115.98:22/home/git/api.nbdon.com

git remote add origin ssh://git@116.196.115.98:22/home/git/api.nbdon.com
```

