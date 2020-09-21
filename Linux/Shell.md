Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。
Shell 脚本（shell script），是一种为 shell 编写的脚本程序。

## 第一个shell脚本

```
vim Test.sh 
#!/bin/bash
echo "Hello World !"
```

```
Test.sh 
chmod +x ./test.sh
./test.sh
```

## 变量

```
your_name  = "runoob.com"
echo $your_name
echo ${your_name}
```


只读变量

```
myUrl = “meiyoufan.com”
Readonly MyUrl
myUrl= “nbdon.com”
```

删除变量

```
unset variable_name
```


## 变量类型
1. 局部变量

2. 环境变量

3. Shell变量

 单双引号
 拼接字符串
 获取字符串长度

```
string = “abcd”
echo ${#string}
```


提取字符串

```
echo ${#string:1:4}
```

查找字符串

```
echo ‘expr index “$string”io’
```

数组

```
Array_name = (value0 value1 value2)
Array_name[0]=value0
Array_name[1]=value1
Echo ${array_name[@]}
```

获取数组长度

```
Length = ${#array_name[@]}
Length=${#array_name[*]}
Length=${#array_name[n]}
```


## Linux 命令大全

1、文件管理

```
cat	chattr	chgrp	chmod
chown	cksum	cmp	diff
diffstat	file	find	git
gitview	indent	cut	ln
less	locate	lsattr	mattrib
mc	mdel	mdir	mktemp
more	mmove	mread	mren
mtools	mtoolstest	mv	od
paste	patch	rcp	rm
slocate	split	tee	tmpwatch
touch	umask	which	cp
whereis	mcopy	mshowfat	rhmask
scp	awk	read	updatedb
```

2、文档编辑

```
col	colrm	comm	csplit
ed	egrep	ex	fgrep
fmt	fold	grep	ispell
jed	joe	join	look
mtype	pico	rgrep	sed
sort	spell	tr	expr
uniq	wc	let	 
3、文件传输
lprm	lpr	lpq	lpd
bye	ftp	uuto	uupick
uucp	uucico	tftp	ncftp
ftpshut	ftpwho	ftpcount
```

4、磁盘管理

```
cd	df	dirs	du
edquota	eject	mcd	mdeltree
mdu	mkdir	mlabel	mmd
mrd	mzip	pwd	quota
mount	mmount	rmdir	rmt
stat	tree	umount	ls
quotacheck	quotaoff	lndir	repquota
quotaon	
```

5、磁盘维护

```
badblocks	cfdisk	dd	e2fsck
ext2ed	fsck	fsck.minix	fsconf
fdformat	hdparm	mformat	mkbootdisk
mkdosfs	mke2fs	mkfs.ext2	mkfs.msdos
mkinitrd	mkisofs	mkswap	mpartition
swapon	symlinks	sync	mbadblocks
mkfs.minix	fsck.ext2	fdisk	losetup
mkfs	sfdisk	swapoff	 
```

6、网络通讯

```
apachectl	arpwatch	dip	getty
mingetty	uux	telnet	uulog
uustat	ppp-off	netconfig	nc
httpd	ifconfig	minicom	mesg
dnsconf	wall	netstat	ping
pppstats	samba	setserial	talk
traceroute	tty	newaliases	uuname
netconf	write	statserial	efax
pppsetup	tcpdump	ytalk	cu
smbd	testparm	smbclient	shapecf
```

7、系统管理

```
adduser	chfn	useradd	date
exit	finger	fwhios	sleep
suspend	groupdel	groupmod	halt
kill	last	lastb	login
logname	logout	ps	nice
procinfo	top	pstree	reboot
rlogin	rsh	sliplogin	screen
shutdown	rwho	sudo	gitps
swatch	tload	logrotate	uname
chsh	userconf	userdel	usermod
vlock	who	whoami	whois
newgrp	renice	su	skill
w	id	groupadd	free
```

8、系统设置

```
reset	clear	alias	dircolors
aumix	bind	chroot	clock
crontab	declare	depmod	dmesg
enable	eval	export	pwunconv
grpconv	rpm	insmod	kbdconfig
lilo	liloconfig	lsmod	minfo
set	modprobe	ntsysv	mouseconfig
passwd	pwconv	rdate	resize
rmmod	grpunconv	modinfo	time
setup	sndconfig	setenv	setconsole
timeconfig	ulimit	unset	chkconfig
apmd	hwclock	mkkickstart	fbset
unalias	SVGATextMode	gpasswd	
```

9、备份压缩

```
ar	bunzip2	bzip2	bzip2recover
gunzip	unarj	compress	cpio
dump	uuencode	gzexe	gzip
lha	restore	tar	uudecode
unzip	zip	zipinfo	
```

10、设备管理

```
setleds	loadkeys	rdev	dumpkeys
MAKEDEV	poweroff	 
```


​			
其他命令

Linux bc 命令

Linux tail 命令

Linux head 命令

Linux xargs 命令

Linux ip 命令

Linux nohup 命令

Linux killall 命令

Linux pkill 命令

扩展文章
Linux 常用命令全拼
Shell 文件包含
Nginx 安装配置 