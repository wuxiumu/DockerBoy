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
1
```

# Q6

git fetch
git pull

------

更新ing

[参考文献]
[1]https://www.jianshu.com/p/664bb86a11e2
[2]https://www.cnblogs.com/ningkyolei/p/4334990.html#undefined
[3]https://blog.csdn.net/sinat_36246371/article/details/79995661
[4]https://blog.csdn.net/feng2qing/article/details/56496441
[5]https://www.cnblogs.com/warrior/p/10717186.html