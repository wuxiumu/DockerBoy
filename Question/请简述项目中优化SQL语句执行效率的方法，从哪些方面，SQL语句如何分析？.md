### 文章目录

- [一、考点](https://blog.csdn.net/studyphp123/article/details/83756823#_1)

- - - [1、查找分析查询速度慢的原因](https://blog.csdn.net/studyphp123/article/details/83756823#1_3)

    - - [1）分析SQL查询慢的方法](https://blog.csdn.net/studyphp123/article/details/83756823#1SQL_5)
      - [2）使用 show profile](https://blog.csdn.net/studyphp123/article/details/83756823#2_show_profile_11)
      - [3）使用 show status](https://blog.csdn.net/studyphp123/article/details/83756823#3_show_status_19)
      - [4）使用 show processlist](https://blog.csdn.net/studyphp123/article/details/83756823#4_show_processlist_26)
      - [5）使用 explain](https://blog.csdn.net/studyphp123/article/details/83756823#5_explain_32)

    - [2、优化查询过程中的数据访问](https://blog.csdn.net/studyphp123/article/details/83756823#2_38)

    - - [1）访问数据太多导致性能下降](https://blog.csdn.net/studyphp123/article/details/83756823#1_40)
      - [2）确定应用程序是否在检索大量超过需要的数据，可能是太多行或列](https://blog.csdn.net/studyphp123/article/details/83756823#2_46)
      - [3）确认 MySQL服务器是否在分析大量不必要的数据行](https://blog.csdn.net/studyphp123/article/details/83756823#3_MySQL_52)
      - [4）避免使用如下SQL语句](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred4SQLfont_56)
      - [5）重复查询相同的数据，可以缓存数据，下次直接读取缓存](https://blog.csdn.net/studyphp123/article/details/83756823#5_64)
      - [6）是否在扫描额外的记录](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred6_68)

    - [3、优化长难的查询语句](https://blog.csdn.net/studyphp123/article/details/83756823#3_77)

    - - [一个复杂查询好 还是 过个 简单查询好？？？](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred___font_79)
      - [1）切分查询](https://blog.csdn.net/studyphp123/article/details/83756823#1_84)
      - [2）分解关联查询](https://blog.csdn.net/studyphp123/article/details/83756823#2_91)

    - [4、优化特定类型的查询语句](https://blog.csdn.net/studyphp123/article/details/83756823#4_101)

    - - [1）优化 count() 查询](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred1_count_font_103)

      - [2）优化关联查询](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred2font_114)

      - [3）优化子查询（即嵌套查询）](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred3font_121)

      - [4）优化 GROUP BY 和 DISTINCT](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred4_GROUP_BY__DISTINCTfont_127)

      - [5）优化 LIMIT 分页](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred5_LIMIT_font_137)

      - - [解决方法：](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorredfont_141)

      - [6）优化 UNION 查询](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorred6_UNION_font_147)

- [二、解题方法](https://blog.csdn.net/studyphp123/article/details/83756823#_153)

- [三、真题](https://blog.csdn.net/studyphp123/article/details/83756823#_159)

- - - [SQL语句优化的一些方法。](https://blog.csdn.net/studyphp123/article/details/83756823#SQL_161)

    - - [注：此题可以根据以上的内容进行一个详细的总结。](https://blog.csdn.net/studyphp123/article/details/83756823#font_colorredfont_180)



# 一、考点

### 1、查找分析查询速度慢的原因

#### 1）分析SQL查询慢的方法

> - 记录 **慢查询日志**；
> - **分析查询日志，不要直接打开慢查询日志进行分析，这样比较浪费时间和精力，可以使用 `pt-query-digest`工具 进行分析。**



#### 2）使用 show profile

> - `set profiling = 1`; 开启，服务器上执行的所有语句会检测消耗的时间，存到临时表中。
> - `show profiles`;
> - `show profile for query` 临时表ID；



#### 3）使用 show status

> - `show status` 会返回一些计数器， `show global status` 查看服务器级别的所有计数；
> - 有时根据这些计数，可以猜测出哪些操作代价较高或者消耗时间多。



#### 4）使用 show processlist

> - 观察是否有大量线程处于不正常的状态或者特征。



#### 5）使用 explain

> - 分析单条SQL语句。



### 2、优化查询过程中的数据访问

#### 1）访问数据太多导致性能下降

> 不要使用 `SELECT *`。



#### 2）确定应用程序是否在检索大量超过需要的数据，可能是太多行或列

> 如：一个应用程序在某个步骤下，只需要获取到 10列中的两列的50条数据，但是在查询的时候，特别贪婪的把所有的数据所有列的内容全部都查询了出来，这样本身就是不合理的，所以我们要确定该情况是否存在。



#### 3）确认 MySQL服务器是否在分析大量不必要的数据行



#### 4）避免使用如下SQL语句

> - 查询不需要的记录，使用 `limit` 解决；
> - 多表关联返回全部列，指定 `A.id`, `A.name`, `B.age`；
> - 总是取出全部列，`SELECT *` 会让优化器无法完成索引覆盖扫描的优化。



#### 5）重复查询相同的数据，可以缓存数据，下次直接读取缓存



#### 6）是否在扫描额外的记录

> 使用 `explain` 来进行分析，如果发现查询需要扫描大量的数据，但只返回少数的行，可以通过如下技巧去优化：
>
> - 使用索引覆盖扫描，把所有用的列都放到索引中，这样存储引擎不需要回表获取对应行，就可以返回结果；
> - 改变数据库和表的结构，修改数据表范式；
> - 重写SQL语句，让优化器可以以更优的方式执行查询



### 3、优化长难的查询语句

#### 一个复杂查询好 还是 过个 简单查询好？？？

> - MySQL内部每秒能扫描内存中上百万行数据，相比之下，响应数据给客户端就要慢很多；
> - 使用尽可能少的查询是好的，但是有时将一个大的查询分解为多个小的查询是很有必要的。

#### 1）切分查询

> - 将一个大的查询分为多个小的相同的查询；
> - 一次性删除 1000万 的数据要比一次删除1万，暂停一会的方案更加损耗服务器开销。



#### 2）分解关联查询

> - 可以将一条关联语句分解成多条SQL来执行；
> - 让缓存的效率更高；
> - 执行单个查询可以减少锁的竞争；
> - 查询效率会有大幅提升；
> - 较少冗余记录的查询。



### 4、优化特定类型的查询语句

#### 1）优化 count() 查询

> - `count(*)` 中的 `*` 会忽略所有的列，直接统计所有列数，因此不要使用 `count(列名)`；
>
> - MyISAM中，没有任何 `WHERE` 条件的 `count(*)` 会非常快；
>
> - 当有
>
>    
>
>   ```
>   WHERE
>   ```
>
>    
>
>   条件，MyISAM的
>
>    
>
>   ```
>   count
>   ```
>
>   统计不一定比其他引擎快
>
>   - 可以使用 `explain`进行全表扫描，查询近似值，用近似值替代 `count(*)`；
>   - 增加汇总表（每次修改信息就修改一下汇总表）；
>   - 使用缓存（每次查询的时候，查询汇总表即可，可以把汇总表做成缓存）；



#### 2）优化关联查询

> - 确定 `ON` 或者 `USING` 子句的列上是否有索引（如果没有，则一定要建立索引，没有索引会导致全表扫描，对查询的效率）；
> - 确保 `GROUP BY` 和 `ORDER BY` 中只有一个表中的列，这样 MySQL 才有可能使用索引。



#### 3）优化子查询（即嵌套查询）

> 尽可能使用关联查询来替代。



#### 4）优化 GROUP BY 和 DISTINCT

这两种查询均可使用 **索引** 来优化，是 **最有效的优化方法**.

> - 关联查询中，使用 **标识列** 进行分组的效率会更高（即 使用 `GROUP BY` 的时候，尽量使用 **主键列**，或者是 `auto_increment` 这样的列来做分组，效率会更高）；
> - 如果不需要 `ORDER BY`，进行 `GROUP BY` 时使用 `ORDER BY NULL` ，MySQL不会再进行文件排序（否则有可能进行文件排序，导致性能消耗）；
> - `WITH ROLLUP` 超级聚合，可以挪到应用程序处理。



#### 5）优化 LIMIT 分页

> `LIMIT` 偏移量大的时候，查询效率较低.

##### 解决方法：

> 可以记录上次查询的 最大ID，下次查询时直接根据该ID来查询（如： `limit 0,100`，加个 `where`条件 ，`where id > '上次查询的最大ID'`，虽然这样的值并不一定很精确，但是我们可以用其他的方法，进行数据上的弥补）。



#### 6）优化 UNION 查询

> `UNION ALL`的效率高于 `UNION`（用 `UNION ALL` 来优化 `UNION`，`UNION ALL` 会将重复的数据显示出来，**可以在应用层面把重复的数据筛掉，但是我们查询的时候，还使用 `UNION ALL`**, 对MySQL的性能损耗会降低很多，提高我们的查询效率）。



# 二、解题方法

> 对于此类考题，先说明如何定位低效SQL语句，然后根据SQL语句可能低效的原因做排查，先从索引着手，如果索引没有问题，考虑以上几个方面，数据访问的问题，长难查询句的问题还是一些特定类型优化的问题，逐一回答。



# 三、真题

### SQL语句优化的一些方法。

- **优化查询过程中的数据访问**；

> - 访问数据太多导致性能下降;
> - 确定应用程序是否在检索大量超过需要的数据，可能是太多行或列；
> - 确认 MySQL服务器是否在分析大量不必要的数据行；
> - 重复查询相同的数据，可以缓存数据，下次直接读取缓存；
> - 是否在扫描额外的记录。

- **优化长难的查询语句**；

> - 切分查询；
> - 分解关联查询

- **优化特定类型的查询语句**；

> - 优化 count() 查询；
> - 优化关联查询；
> - 优化子查询（即嵌套查询）；
> - 优化 GROUP BY 和 DISTINCT；
> - 优化 LIMIT 分页；
> - 优化 UNION 查询。

#### 注：此题可以根据以上的内容进行一个详细的总结。