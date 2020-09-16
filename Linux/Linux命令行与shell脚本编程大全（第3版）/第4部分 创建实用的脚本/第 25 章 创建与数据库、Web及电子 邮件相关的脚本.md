7本章内容
 编写数据库shell脚本
 在脚本中使用互联网
 在脚本中发送电子邮件



# [Linux—编写shell脚本操作数据库执行sql](https://www.cnblogs.com/Andya/p/12524370.html)

# 修改数据库数据

  在升级应用时，我们常常会遇到升级数据库的问题，这就涉及到sql脚本的编写。
  一般我们会通过写sql脚本，然后将xxx.sql脚本放到数据库中进行`source xxx.sql`执行。本篇文章，我们可以通过写shell脚本来执行数据库操作。

# 配置文件

创建 test_sql.properties 作为shell脚本的外部配置参数修改：

```java
[andya@liunx01 sql_sh]$ vim test_sql.properties
# set parameters start

# 1 db name
dbName="db01"


# 2 the valueof net  speeds and requests 
netMaxSpeeds=500
netRequests="test.t1"


# 3 database info 
## mysql address
MYSQL_ADDRESS="10.127.0.1" 
## database name
MYSQL_DATABASE_NAME="db_test" 
## 5.3 bdoc connect mysql user name
MYSQL_USER="user01" 
## 5.4 bdoc connect mysql user password
MYSQL_PASSWD="123456" 
## 5.5  mysql engine
DATABASE_ENGINE=mysql
```

# shell脚本

创建shell脚本test_sql.sh

```java
[andya@liunx01 sql_sh]$ vim test_sql.sh
#!/bin/bash
starttime=$(date +%Y-%m-%d\ %H:%M:%S)
echo "【Start to execute the script】， start time is: " $starttime   >> test_sql_sh.log

# 1 read parameters
# ===================================================================
echo "------ test_sql.properties start------" >> test_sql_sh.log

source ./test_sql.properties
echo "Parameters: cat test_sql.properties" >> test_sql_sh.log

while read line
do
 echo $line >> test_sql_sh.log ;
done < test_sql.properties

echo "------ test_sql.properties end------" >> test_sql_sh.log
# =================================================================

# 2 update database
# ========================
testSql="
SET @dbId=(SELECT id FROM ${MYSQL_DATABASE_NAME}.\`test_tb01\` WHERE \`NAME\` = \"${dbName}\");
INSERT INTO ${MYSQL_DATABASE_NAME}.\`test_tb02\` (\`NAME\`, \`DB_ID\` ,\`MAX_SPEEDS\`, \`NET_REQUESTS\`) VALUES ('${dbName}', @dbId, '${netMaxSpeeds}', '${netRequests}');
"

echo -e "\nSql: add hbase sql is: "${testSql} >> test_sql_sh.log

id=$(${DATABASE_ENGINE} -h${MYSQL_ADDRESS} -u${MYSQL_USER} -p${MYSQL_PASSWD} -D ${MYSQL_DATABASE_NAME} -e "${testSql}")
echo "Sql: Modify db data successfully, and insert db id is: "${id} >> test_sql_sh.log

endtime=`date +"%Y-%m-%d %H:%M:%S"`
echo "【Execute the script end】, end time is: " ${endtime} >> test_sql_sh.log
echo -e "\n" >> test_sql_sh.log

exit 0
```

# 脚本执行

`./test_sql.sh`
并且可以查看到输出日志test_sql_sh.log

# 另一种连接方式（待研究）

```java
#!/bin/sh
mysql_engine=`which mysql`
${mysql_engine} -uroot -p123456 <<EOF 1>>test.log
use db01;
select * from tb01 where id = 4;
EOF
exit 0
```

其中：
1）`1>>test.log`是重定向标准输出到test.log中，当然，也尝试去掉1，也是可以输出。
2）我们也可以使用`2 >/dev/null`重定向来屏蔽错误信息，2即为标准错误输出，对于linux来说`/dev/null`即为空设备，输入进去的数据即为丢弃。
3）EOF表示后续输入作为shell的输入，直到下一个EOF出现，再返回主进程shell中。

烧不死的鸟就是凤凰

分类: [Linux](https://www.cnblogs.com/Andya/category/1662928.html)

标签: [shell操作数据库](https://www.cnblogs.com/Andya/tag/shell操作数据库/), [编写shell脚本操作数据库](https://www.cnblogs.com/Andya/tag/编写shell脚本操作数据库/), [shell执行sql脚本](https://www.cnblogs.com/Andya/tag/shell执行sql脚本/), [shell sql](https://www.cnblogs.com/Andya/tag/shell sql/)