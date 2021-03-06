本章内容
 理解Linux的安全性
 解读文件权限
 使用Linux组

本章讨论了管理Linux系统安全性需要知道的一些命令行命令。 Linux通过用户ID和组ID来限
制对文件、目录以及设备的访问。Linux将用户账户的信息存储在/etc/passwd文件中,将组信息存
储在/etc/group文件中。每个用户都会被分配唯一的用户ID,以及在系统中识别用户的文本登录名。
组也会被分配唯一的组ID以及组名。组可以包含一个或多个用户以支持对系统资源的共享访问。
有若干命令可以用来管理用户账户和组。 useradd 命令用来创建新的用户账户, groupadd
命令用来创建新的组账户。修改已有用户账户,我们用 usermod 命令。类似的 groupmod 命令用
来修改组账户信息。
Linux采用复杂的位系统来判定文件和目录的访问权限。每个文件都有三个安全等级:文件
的属主、能够访问文件的默认属组以及系统上的其他用户。每个安全等级通过三个访问权限位来
定义:读取、写入以及执行,对应于符号 rwx 。如果某种权限被拒绝,权限对应的符号会用单破
折线代替(比如 r-- 代表只读权限)。
这种符号权限通常以八进制值来描述。3位二进制组成一个八进制值,3个八进制值代表了3
个安全等级。 umask 命令用来设置系统中所创建的文件和目录的默认安全设置。系统管理员通常
会在/etc/profile文件中设置一个默认的 umask 值,但你可以随时通过 umask 命令来修改自己的
umask 值。
chmod 命令用来修改文件和目录的安全设置。只有文件的属主才能改变文件或目录的权限。
不过root用户可以改变系统上任意文件或目录的安全设置。 chown 和 chgrp 命令可用来改变文件
默认的属主和属组。
本章最后讨论了如何使用设置组ID位来创建共享目录。SGID位会强制某个目录下创建的新
文件或目录都沿用该父目录的属组,而不是创建这些文件的用户的属组。这可以为系统的用户之
间共享文件提供一个简便的途径。
现在你已经了解了文件权限,下面就可以进一步了解如何使用实际的Linux文件系统了。下
一章将会介绍如何使用命令行在Linux上创建新的分区,以及如何格式化新分区以使其可用于
Linux虚拟目录。