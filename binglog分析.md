# Binlog分析
**目录**
[TOC]
```shell
update操作：
root@mysqldb 10:37:  [lvcheng]> update tt set name = 'appl' where id = 10;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

binlog的内容变化如下：
# at 3072
#170728 10:06:56 server id 113306  end_log_pos 3103 CRC32 0x28d6d313 	Xid = 353
COMMIT/*!*/;
# at 3103
#170728 10:38:53 server id 113306  end_log_pos 3168 CRC32 0x7d692db2 	Anonymous_GTID	last_committed=11	sequence_number=12
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 3168
#170728 10:38:53 server id 113306  end_log_pos 3243 CRC32 0x5ae75581 	Query	thread_id=42	exec_time=0	error_code=0
SET TIMESTAMP=1501209533/*!*/;
BEGIN
/*!*/;
# at 3243
#170728 10:38:53 server id 113306  end_log_pos 3296 CRC32 0x1b8af68a 	Table_map: `lvcheng`.`tt` mapped to number 243
# at 3296
#170728 10:38:53 server id 113306  end_log_pos 3361 CRC32 0x49f0ef99 	Update_rows: table id 243 flags: STMT_END_F
### UPDATE `lvcheng`.`tt`
### WHERE
###   @1=10
###   @2=1501207600
###   @3='apple'
### SET
###   @1=10
###   @2=1501207600
###   @3='appl'
# at 3361
#170728 10:38:53 server id 113306  end_log_pos 3392 CRC32 0x98c3b295 	Xid = 1851
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;

# 每个事务的结束点，是以 'Xid = ' 来查找
# 事务的开始时间，是事务内的第一个 'Table_map' 行里边的时间
# 事务的结束时间，是以 'Xid = '所在行的 里边的时间
# 每个行数据是属于哪个表格，是以 'Table_map'来查找
# DML的类型是按照 行记录开头的情况是否为：'### INSERT INTO'  、'### UPDATE' 、'### DELETE FROM' 
# 注意，单个事务可以包含多个表格多种DML多行数据修改的情况。

事务组内容：
root@mysqldb 10:38:  [lvcheng]> show binlog events in 'mybinlog.000018' from 3103 limit 10;
+-----------------+------+----------------+-----------+-------------+--------------------------------------+
| Log_name        | Pos  | Event_type     | Server_id | End_log_pos | Info                                 |
+-----------------+------+----------------+-----------+-------------+--------------------------------------+
| mybinlog.000018 | 3103 | Anonymous_Gtid |    113306 |        3168 | SET @@SESSION.GTID_NEXT= 'ANONYMOUS' |
| mybinlog.000018 | 3168 | Query          |    113306 |        3243 | BEGIN                                |
| mybinlog.000018 | 3243 | Table_map      |    113306 |        3296 | table_id: 243 (lvcheng.tt)           |
| mybinlog.000018 | 3296 | Update_rows    |    113306 |        3361 | table_id: 243 flags: STMT_END_F      |
| mybinlog.000018 | 3361 | Xid            |    113306 |        3392 | COMMIT /* xid=1851 */                |
+-----------------+------+----------------+-----------+-------------+--------------------------------------+
5 rows in set (0.00 sec)
```
* 离线解析通过mysqbinlog
```shell
[root@mysql1 logs]# mysqlbinlog --base64-output=decode-rows -v mybinlog.000018 | grep -i -e "^### " -e "^alter" | sed 's/^### //'

INSERT INTO `lvcheng`.`tt`
SET
  @1=2
  @2=1501207299
INSERT INTO `lvcheng`.`tt`
SET
  @1=3
  @2=1501207303
INSERT INTO `lvcheng`.`tt`
SET
  @1=4
  @2=1501207306
INSERT INTO `lvcheng`.`tt`
SET
  @1=5
  @2=1501207309
INSERT INTO `lvcheng`.`tt`
SET
  @1=6
  @2=1501207314
INSERT INTO `lvcheng`.`tt`
SET
  @1=7
  @2=1501207323
INSERT INTO `lvcheng`.`tt`
SET
  @1=8
  @2=1501207327
alter table tt add column name varchar(30)
INSERT INTO `lvcheng`.`tt`
SET
  @1=9
  @2=1501207580
  @3='lala'
INSERT INTO `lvcheng`.`tt`
SET
  @1=10
  @2=1501207600
  @3='haha'
UPDATE `lvcheng`.`tt`
WHERE
  @1=10
  @2=1501207600
  @3='haha'
SET
  @1=10
  @2=1501207600
  @3='apple'
UPDATE `lvcheng`.`tt`
WHERE
  @1=10
  @2=1501207600
  @3='apple'
SET
  @1=10
  @2=1501207600
  @3='appl'
UPDATE `lvcheng`.`tt`
WHERE
  @1=10
  @2=1501207600
  @3='appl'
SET
  @1=10
  @2=1501207600
  @3='app'
DELETE FROM `lvcheng`.`tt`
WHERE
  @1=10
  @2=1501207600
  @3='app'
UPDATE `lvcheng`.`tt`
WHERE
  @1=9
  @2=1501207580
  @3='lala'
SET
  @1=9
  @2=1501210804
  @3='dd'
INSERT INTO `lvcheng`.`tt`
SET
  @1=10
  @2=1501210804
  @3='ss'
UPDATE `lvcheng`.`tt`
WHERE
  @1=10
  @2=1501210804
  @3='ss'
SET
  @1=10
  @2=1501210844
  @3='sd'
INSERT INTO `lvcheng`.`tt`
SET
  @1=11
  @2=1501210844
  @3='ss'
```



# binlog2sql工具

从MySQL binlog解析出你要的SQL。根据不同选项，你可以得到原始SQL、回滚SQL、去除主键的INSERT SQL等。

## 用途

* 数据快速回滚（闪回）
* 主从切换后master丢数据的修复
* 从binlog生成标准SQL，带来的衍生功能

## 限制
* mysql server必须开启，离线模式下不能解析
* 参数 binlog_row_image 必须为FULL，暂不支持MINIMAL
* 解析速度不如mysqlbinlog

## 安装

```shell
shell> git clone https://github.com/danfengcao/binlog2sql.git && cd binlog2sql
[root@mysql1 binlog2sql]# ll
总用量 52
drwxr-xr-x. 2 root root    95 7月  28 13:59 binlog2sql
drwxr-xr-x. 2 root root    53 7月  28 13:39 example
-rw-r--r--. 1 root root 35141 7月  28 13:39 LICENSE
-rw-r--r--. 1 root root  9110 7月  28 13:39 README.md
-rw-r--r--. 1 root root    54 7月  28 13:39 requirements.txt
drwxr-xr-x. 2 root root    36 7月  28 13:39 tests

[root@mysql1 binlog2sql]# yum -y install epel-release
[root@mysql1 binlog2sql]# yum -y install python-pip
[root@mysql1 binlog2sql]# yum clean all
[root@mysql1 binlog2sql]# pip install --upgrade pip

shell> pip install -r requirements.txt

[root@mysql1 binlog2sql]# cat requirements.txt 
PyMySQL==0.7.11
wheel==0.29.0
mysql-replication==0.13
[root@mysql1 binlog2sql]# pip install -r requirements.txt 
Requirement already satisfied: PyMySQL==0.7.11 in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 1))
Requirement already satisfied: wheel==0.29.0 in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 2))
Requirement already satisfied: mysql-replication==0.13 in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 3))
```

## 使用

MySQL server必须设置以下参数:

```shell
[mysqld]
server_id = 1
log_bin = /var/log/mysql/mysql-bin.log
max_binlog_size = 1G
binlog_format = row
binlog_row_image = full
```

user需要的最小权限集合：

```shell
select, super/replication client, replication slave

建议授权
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 
```

权限说明

* select：需要读取server端information_schema.COLUMNS表，获取表结构的元信息，拼接成可视化的sql语句
* super/replication client：两个权限都可以，需要执行'SHOW MASTER STATUS', 获取server端的binlog列表
* replication slave：通过BINLOG_DUMP协议获取binlog内容的权限

## 基础用法

### 解析出标准SQL

```shell
[root@mysql1 binlog2sql]# python binlog2sql.py -h127.0.0.1 -P3306 -uroot -p123 -dlvcheng -t tt --start-file='mybinlog.000018'
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (2, '2017-07-28 10:01:39'); #start 4 end 396 time 2017-07-28 10:01:39
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (3, '2017-07-28 10:01:43'); #start 427 end 669 time 2017-07-28 10:01:43
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (4, '2017-07-28 10:01:46'); #start 700 end 942 time 2017-07-28 10:01:46
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (5, '2017-07-28 10:01:49'); #start 973 end 1215 time 2017-07-28 10:01:49
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (6, '2017-07-28 10:01:54'); #start 1246 end 1488 time 2017-07-28 10:01:54
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (7, '2017-07-28 10:02:03'); #start 1519 end 1761 time 2017-07-28 10:02:03
INSERT INTO `lvcheng`.`tt`(`id`, `t`) VALUES (8, '2017-07-28 10:02:07'); #start 1792 end 2034 time 2017-07-28 10:02:07
USE lvcheng;
alter table tt add column name varchar(30);
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (9, 'lala', '2017-07-28 10:06:20'); #start 2252 end 2502 time 2017-07-28 10:06:20
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (10, 'haha', '2017-07-28 10:06:40'); #start 2533 end 2783 time 2017-07-28 10:06:40
UPDATE `lvcheng`.`tt` SET `id`=10, `name`='apple', `t`='2017-07-28 10:06:40' WHERE `id`=10 AND `name`='haha' AND `t`='2017-07-28 10:06:40' LIMIT 1; #start 2814 end 3072 time 2017-07-28 10:06:56
UPDATE `lvcheng`.`tt` SET `id`=10, `name`='appl', `t`='2017-07-28 10:06:40' WHERE `id`=10 AND `name`='apple' AND `t`='2017-07-28 10:06:40' LIMIT 1; #start 3103 end 3361 time 2017-07-28 10:38:53
UPDATE `lvcheng`.`tt` SET `id`=10, `name`='app', `t`='2017-07-28 10:06:40' WHERE `id`=10 AND `name`='appl' AND `t`='2017-07-28 10:06:40' LIMIT 1; #start 3392 end 3648 time 2017-07-28 10:45:49
DELETE FROM `lvcheng`.`tt` WHERE `id`=10 AND `name`='app' AND `t`='2017-07-28 10:06:40' LIMIT 1; #start 3679 end 3920 time 2017-07-28 10:56:22
UPDATE `lvcheng`.`tt` SET `id`=9, `name`='dd', `t`='2017-07-28 11:00:04' WHERE `id`=9 AND `name`='lala' AND `t`='2017-07-28 10:06:20' LIMIT 1; #start 3951 end 4214 time 2017-07-28 11:00:04
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (10, 'ss', '2017-07-28 11:00:04'); #start 3951 end 4261 time 2017-07-28 11:00:04
UPDATE `lvcheng`.`tt` SET `id`=10, `name`='sd', `t`='2017-07-28 11:00:44' WHERE `id`=10 AND `name`='ss' AND `t`='2017-07-28 11:00:04' LIMIT 1; #start 4292 end 4553 time 2017-07-28 11:00:44
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (11, 'ss', '2017-07-28 11:00:44'); #start 4292 end 4600 time 2017-07-28 11:00:44
```

### 解析出回滚SQL

```shell
[root@mysql1 binlog2sql]# python binlog2sql.py -h127.0.0.1 -P3306 -uroot -p123 -dlvcheng -t tt --start-file='mybinlog.000018' --start-position=3168 --stop-position=3361
UPDATE `lvcheng`.`tt` SET `id`=10, `name`='appl', `t`='2017-07-28 10:06:40' WHERE `id`=10 AND `name`='apple' AND `t`='2017-07-28 10:06:40' LIMIT 1; #start 3168 end 3361 time 2017-07-28 10:38:53
```

## 选项

**mysql连接配置**

-h host; -P port; -u user; -p password

**解析模式**

--stop-never 持续同步binlog。可选。不加则同步至执行命令时最新的binlog位置。

-K, --no-primary-key 对INSERT语句去除主键。可选。

-B, --flashback 生成回滚语句，可解析大文件，不受内存限制，每打印一千行加一句SLEEP SELECT(1)。可选。与stop-never或no-primary-key不能同时添加。

**解析范围控制**

--start-file 起始解析文件。必须。

--start-position/--start-pos start-file的起始解析位置。可选。默认为start-file的起始位置。

--stop-file/--end-file 末尾解析文件。可选。默认为start-file同一个文件。若解析模式为stop-never，此选项失效。

--stop-position/--end-pos stop-file的末尾解析位置。可选。默认为stop-file的最末位置；若解析模式为stop-never，此选项失效。

--start-datetime 从哪个时间点的binlog开始解析，格式必须为datetime，如'2016-11-11 11:11:11'。可选。默认不过滤。

--stop-datetime 到哪个时间点的binlog停止解析，格式必须为datetime，如'2016-11-11 11:11:11'。可选。默认不过滤。

**对象过滤**

-d, --databases 只输出目标db的sql。可选。默认为空。

-t, --tables 只输出目标tables的sql。可选。默认为空。



# 应用案例
误删整张表数据，需要紧急回滚
```shell
root@mysqldb 11:53:  [lvcheng]> select * from tt;
+----+---------------------+------+
| id | t                   | name |
+----+---------------------+------+
|  1 | 2017-07-27 17:33:13 | NULL |
|  2 | 2017-07-28 10:01:39 | NULL |
|  3 | 2017-07-28 10:01:43 | NULL |
|  4 | 2017-07-28 10:01:46 | NULL |
|  5 | 2017-07-28 10:01:49 | NULL |
|  6 | 2017-07-28 10:01:54 | NULL |
|  7 | 2017-07-28 10:02:03 | NULL |
|  8 | 2017-07-28 10:02:07 | NULL |
|  9 | 2017-07-28 11:00:04 | dd   |
| 10 | 2017-07-28 11:00:44 | sd   |
| 11 | 2017-07-28 11:00:44 | ss   |
+----+---------------------+------+
11 rows in set (0.00 sec)

root@mysqldb 11:55:  [lvcheng]> delete from tt;
ERROR 2006 (HY000): MySQL server has gone away
No connection. Trying to reconnect...
Connection id:    275
Current database: lvcheng

Query OK, 11 rows affected (0.01 sec)

root@mysqldb 14:15:  [lvcheng]> select * from tt;
Empty set (0.00 sec)

root@mysqldb 14:15:  [lvcheng]> show master status;
+-----------------+----------+--------------+------------------+-------------------+
| File            | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+-----------------+----------+--------------+------------------+-------------------+
| mybinlog.000018 |     4998 |              |                  |                   |
+-----------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

root@mysqldb 14:15:  [lvcheng]> 
```

## 恢复步骤
* 登录mysql，查看目前的binlog文件

```shell
root@mysqldb 14:15:  [lvcheng]> show master status;
+-----------------+----------+--------------+------------------+-------------------+
| File            | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+-----------------+----------+--------------+------------------+-------------------+
| mybinlog.000018 |     4998 |              |                  |                   |
+-----------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

* 最新的binlog文件是mybinlog.000018，我们再定位误操作SQL的binlog位置。误操作人只能知道大致的误操作时间，我们根据大致时间过滤数据

```shell
[root@mysql1 binlog2sql]# python binlog2sql.py -h127.0.0.1 -P3306 -uroot -p123 -dlvcheng -t tt --start-file='mybinlog.000018' --start-datetime='2017-07-28 14:12:00' --stop-datetime='2017-07-28 14:16:00'
DELETE FROM `lvcheng`.`tt` WHERE `id`=1 AND `name` IS NULL AND `t`='2017-07-27 17:33:13' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=2 AND `name` IS NULL AND `t`='2017-07-28 10:01:39' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=3 AND `name` IS NULL AND `t`='2017-07-28 10:01:43' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=4 AND `name` IS NULL AND `t`='2017-07-28 10:01:46' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=5 AND `name` IS NULL AND `t`='2017-07-28 10:01:49' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=6 AND `name` IS NULL AND `t`='2017-07-28 10:01:54' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=7 AND `name` IS NULL AND `t`='2017-07-28 10:02:03' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=8 AND `name` IS NULL AND `t`='2017-07-28 10:02:07' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=9 AND `name`='dd' AND `t`='2017-07-28 11:00:04' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=10 AND `name`='sd' AND `t`='2017-07-28 11:00:44' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21
DELETE FROM `lvcheng`.`tt` WHERE `id`=11 AND `name`='ss' AND `t`='2017-07-28 11:00:44' LIMIT 1; #start 4631 end 4967 time 2017-07-28 14:15:21

# at 4631
#170728 14:15:21 server id 113306  end_log_pos 4696 CRC32 0xcd6923f5 	Anonymous_GTID	last_committed=16	sequence_number=17
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 4696
#170728 14:15:21 server id 113306  end_log_pos 4771 CRC32 0xa21163b4 	Query	thread_id=275	exec_time=0	error_code=0
SET TIMESTAMP=1501222521/*!*/;
BEGIN
/*!*/;
# at 4771
#170728 14:15:21 server id 113306  end_log_pos 4824 CRC32 0x8a465cc9 	Table_map: `lvcheng`.`tt` mapped to number 243
# at 4824
#170728 14:15:21 server id 113306  end_log_pos 4967 CRC32 0xacf4fc52 	Delete_rows: table id 243 flags: STMT_END_F
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=1
###   @2=1501147993
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=2
###   @2=1501207299
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=3
###   @2=1501207303
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=4
###   @2=1501207306
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=5
###   @2=1501207309
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=6
###   @2=1501207314
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=7
###   @2=1501207323
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=8
###   @2=1501207327
###   @3=NULL
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=9
###   @2=1501210804
###   @3='dd'
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=10
###   @2=1501210844
###   @3='sd'
### DELETE FROM `lvcheng`.`tt`
### WHERE
###   @1=11
###   @2=1501210844
###   @3='ss'
# at 4967
#170728 14:15:21 server id 113306  end_log_pos 4998 CRC32 0x40a93d44 	Xid = 12064
COMMIT/*!*/;
```

* 我们得到了误操作sql的准确位置在4696-4998之间，再根据位置进一步过滤，使用flashback模式生成回滚sql，检查回滚sql是否正确(注：真实环境下，此步经常会进一步筛选出需要的sql。结合grep、编辑器等)
```shell
[root@mysql1 binlog2sql]# python binlog2sql.py -h127.0.0.1 -P3306 -uroot -p123 -dlvcheng -t tt --start-file='mybinlog.000018' --start-position=4696 --stop-position=4998 -B > /tmp/rollback.sql| cat
[root@mysql1 binlog2sql]# cat /tmp/rollback.sql 
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (11, 'ss', '2017-07-28 11:00:44'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (10, 'sd', '2017-07-28 11:00:44'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (9, 'dd', '2017-07-28 11:00:04'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (8, NULL, '2017-07-28 10:02:07'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (7, NULL, '2017-07-28 10:02:03'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (6, NULL, '2017-07-28 10:01:54'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (5, NULL, '2017-07-28 10:01:49'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (4, NULL, '2017-07-28 10:01:46'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (3, NULL, '2017-07-28 10:01:43'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (2, NULL, '2017-07-28 10:01:39'); #start 4696 end 4967 time 2017-07-28 14:15:21
INSERT INTO `lvcheng`.`tt`(`id`, `name`, `t`) VALUES (1, NULL, '2017-07-27 17:33:13'); #start 4696 end 4967 time 2017-07-28 14:15:21
```

* 确认回滚SQL正确，执行回滚语句。登录mysql确认。

```shell
[root@mysql1 binlog2sql]# mysql -uroot -p123 < /tmp/rollback.sql 
mysql: [Warning] Using a password on the command line interface can be insecure.

root@mysqldb 14:15:  [lvcheng]> select * from tt;
ERROR 2006 (HY000): MySQL server has gone away
No connection. Trying to reconnect...
Connection id:    302
Current database: lvcheng

+----+---------------------+------+
| id | t                   | name |
+----+---------------------+------+
|  1 | 2017-07-27 17:33:13 | NULL |
|  2 | 2017-07-28 10:01:39 | NULL |
|  3 | 2017-07-28 10:01:43 | NULL |
|  4 | 2017-07-28 10:01:46 | NULL |
|  5 | 2017-07-28 10:01:49 | NULL |
|  6 | 2017-07-28 10:01:54 | NULL |
|  7 | 2017-07-28 10:02:03 | NULL |
|  8 | 2017-07-28 10:02:07 | NULL |
|  9 | 2017-07-28 11:00:04 | dd   |
| 10 | 2017-07-28 11:00:44 | sd   |
| 11 | 2017-07-28 11:00:44 | ss   |
+----+---------------------+------+
11 rows in set (0.01 sec)

root@mysqldb 14:35:  [lvcheng]> 

```

# 分析RDS for MySQL binlog

```mysql
[root@mysql1 binlog2sql]# python binlog2sql.py -h'rm-bp1k1hlze8ix9rw2zo.mysql.rds.aliyuncs.com' -p3306 -uhjx -p'Zhuyun@123' -dhjxdb -t user --start-file='mysql-bin.000004'
USE mysql;
TRUNCATE TABLE time_zone;
USE mysql;
TRUNCATE TABLE time_zone_name;
USE mysql;
TRUNCATE TABLE time_zone_transition;
USE mysql;
TRUNCATE TABLE time_zone_transition_type;
USE mysql;
ALTER TABLE time_zone_transition ORDER BY Time_zone_id, Transition_time;
USE mysql;
ALTER TABLE time_zone_transition_type ORDER BY Time_zone_id, Transition_type_id;
USE mysql;
/* rds internal mark */ delete from mysql.user where user='hjx';
USE mysql;
/* rds internal mark */ delete from mysql.db where user='hjx';
USE mysql;
/* rds internal mark */ delete from mysql.tables_priv where user='hjx';
USE mysql;
/* rds internal mark */ delete from mysql.columns_priv where user='hjx';
USE mysql;
/* rds internal mark */ flush privileges;
/* rds internal mark */ create user 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.event to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.func to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.general_log to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_category to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_keyword to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_relation to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_topic to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.proc to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.slow_log to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_leap_second to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_name to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_transition to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_transition_type to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on performance_schema.* to 'hjx'@'%';
/* rds internal mark */ flush privileges;
/* rds internal mark */ delete from mysql.db where user='hjx' and db='performance_schema' and db not in(select schema_name from information_schema.schemata);
/* rds internal mark */ flush privileges;
USE hjxdb;
/* rds internal mark */ create database `hjxdb` default character set utf8;
/* rds internal mark */ grant select on mysql.event to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.func to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.general_log to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_category to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_keyword to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_relation to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.help_topic to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.proc to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.slow_log to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_leap_second to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_name to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_transition to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on mysql.time_zone_transition_type to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76';
/* rds internal mark */ grant select on performance_schema.* to 'hjx'@'%';
/* rds internal mark */ flush privileges;
/* rds internal mark */ delete from mysql.db where user='hjx' and db='performance_schema' and db not in(select schema_name from information_schema.schemata);
/* rds internal mark */ flush privileges;
USE mysql;
/* rds internal mark */ delete from mysql.db where user='hjx' and db='hjxdb' and host='%';
USE mysql;
/* rds internal mark */ delete from mysql.tables_priv where user='hjx' and db='hjxdb' and host='%';
USE mysql;
/* rds internal mark */ delete from mysql.columns_priv where user='hjx' and db='hjxdb' and host='%';
USE mysql;
/* rds internal mark */ grant PROCESS,usage, REPLICATION SLAVE, REPLICATION CLIENT  on *.* to 'hjx'@'%' identified by password '*F6BDD106A5612F6C2BAA345AEFADBBE6B3D5AA76' with max_user_connections 0;
USE mysql;
/* rds internal mark */ grant insert,delete,update,select,create,execute,alter,drop,index,CREATE VIEW,LOCK TABLES,CREATE ROUTINE,ALTER ROUTINE,EXECUTE,trigger,show view,event,CREATE TEMPORARY TABLES on `hjxdb`.* to 'hjx'@'%';
USE mysql;
/* rds internal mark */ flush privileges;
USE mysql;
/* rds internal mark */ TRUNCATE TABLE mysql.slow_log;
USE hjxdb;
CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户唯一标志符 UID',
  `username` varchar(64) DEFAULT NULL COMMENT '用户名，不区分大小写',
  `email` varchar(128) DEFAULT NULL COMMENT '注册邮箱，不区分大小写',
  `cell_phone` bigint(11) DEFAULT NULL COMMENT '手机号码',
  `password` char(32) NOT NULL COMMENT '密码hash值',
  `school_code` bigint(20) unsigned DEFAULT NULL COMMENT '学校代码',
  `register_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '注册时间',
  `usertype` int(5) NOT NULL DEFAULT '1' COMMENT '1为微信关注用户，2为微信登录app的用户，3为APP端微信登录的微信用户',
  `state` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1<0: UID是否有效 1<1: 是否设置用户名密码 1<2: 是否认证邮箱 1<3: 是否认证手机号码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `hjxdb`.`user`(`username`, `cell_phone`, `register_time`, `school_code`, `email`, `usertype`, `state`, `password`, `id`) VALUES ('apple', 12233334444, '2017-08-23 13:58:47', 123, 'apple@123.com', 1, 2, 'hahaha', 1); #start 4159786 end 4160028 time 2017-08-23 13:58:47
INSERT INTO `hjxdb`.`user`(`username`, `cell_phone`, `register_time`, `school_code`, `email`, `usertype`, `state`, `password`, `id`) VALUES ('pple', 12233334445, '2017-08-23 13:59:15', 124, 'pple@123.com', 1, 2, 'hahaha', 2); #start 4160902 end 4161142 time 2017-08-23 13:59:15
INSERT INTO `hjxdb`.`user`(`username`, `cell_phone`, `register_time`, `school_code`, `email`, `usertype`, `state`, `password`, `id`) VALUES ('ple', 12233334446, '2017-08-23 13:59:35', 125, 'ple@123.com', 1, 2, 'hahaha', 3); #start 4161751 end 4161989 time 2017-08-23 13:59:35
INSERT INTO `hjxdb`.`user`(`username`, `cell_phone`, `register_time`, `school_code`, `email`, `usertype`, `state`, `password`, `id`) VALUES ('le', 12233334447, '2017-08-23 13:59:52', 126, 'le@123.com', 1, 2, 'hahaha', 4); #start 4162333 end 4162569 time 2017-08-23 13:59:52
UPDATE `hjxdb`.`user` SET `username`='apple', `cell_phone`=15811111111, `register_time`='2017-08-23 13:58:47', `school_code`=123, `email`='apple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=1 WHERE `username`='apple' AND `cell_phone`=12233334444 AND `register_time`='2017-08-23 13:58:47' AND `school_code`=123 AND `email`='apple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=1 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
UPDATE `hjxdb`.`user` SET `username`='pple', `cell_phone`=15811111111, `register_time`='2017-08-23 13:59:15', `school_code`=124, `email`='pple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=2 WHERE `username`='pple' AND `cell_phone`=12233334445 AND `register_time`='2017-08-23 13:59:15' AND `school_code`=124 AND `email`='pple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=2 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
UPDATE `hjxdb`.`user` SET `username`='ple', `cell_phone`=15811111111, `register_time`='2017-08-23 13:59:35', `school_code`=125, `email`='ple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=3 WHERE `username`='ple' AND `cell_phone`=12233334446 AND `register_time`='2017-08-23 13:59:35' AND `school_code`=125 AND `email`='ple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=3 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
UPDATE `hjxdb`.`user` SET `username`='le', `cell_phone`=15811111111, `register_time`='2017-08-23 13:59:52', `school_code`=126, `email`='le@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=4 WHERE `username`='le' AND `cell_phone`=12233334447 AND `register_time`='2017-08-23 13:59:52' AND `school_code`=126 AND `email`='le@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=4 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
USE mysql;
/* rds internal mark */ TRUNCATE TABLE mysql.slow_log;
INSERT INTO `hjxdb`.`user`(`username`, `cell_phone`, `register_time`, `school_code`, `email`, `usertype`, `state`, `password`, `id`) VALUES ('e', 12233334448, '2017-08-23 14:22:39', 127, 'e@123.com', 1, 2, 'hahaha', 5); #start 4197469 end 4197703 time 2017-08-23 14:22:39
UPDATE `hjxdb`.`user` SET `username`='apple', `cell_phone`=12233334444, `register_time`='2017-08-23 13:58:47', `school_code`=123, `email`='apple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=1 WHERE `username`='apple' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:58:47' AND `school_code`=123 AND `email`='apple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=1 LIMIT 1; #start 4201492 end 4201799 time 2017-08-23 14:25:13
UPDATE `hjxdb`.`user` SET `username`='pple', `cell_phone`=12233334445, `register_time`='2017-08-23 13:59:15', `school_code`=124, `email`='pple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=2 WHERE `username`='pple' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:59:15' AND `school_code`=124 AND `email`='pple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=2 LIMIT 1; #start 4201878 end 4202181 time 2017-08-23 14:25:13
UPDATE `hjxdb`.`user` SET `username`='ple', `cell_phone`=12233334446, `register_time`='2017-08-23 13:59:35', `school_code`=125, `email`='ple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=3 WHERE `username`='ple' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:59:35' AND `school_code`=125 AND `email`='ple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=3 LIMIT 1; #start 4202260 end 4202559 time 2017-08-23 14:25:13
UPDATE `hjxdb`.`user` SET `username`='le', `cell_phone`=12233334447, `register_time`='2017-08-23 13:59:52', `school_code`=126, `email`='le@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=4 WHERE `username`='le' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:59:52' AND `school_code`=126 AND `email`='le@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=4 LIMIT 1; #start 4202638 end 4202933 time 2017-08-23 14:25:13
USE mysql;
/* rds internal mark */ TRUNCATE TABLE mysql.slow_log;
USE mysql;
/* rds internal mark */ TRUNCATE TABLE mysql.slow_log;
USE mysql;
/* rds internal mark */ TRUNCATE TABLE mysql.slow_log;


[root@mysql1 binlog2sql]# python binlog2sql.py -h'rm-bp1k1hlze8ix9rw2zo.mysql.rds.aliyuncs.com' -p3306 -uhjx -p'Zhuyun@123' -dhjxdb -t user --start-file='mysql-bin.000004' --start-datetime='2017-08-23 14:00:00' --stop-datetime='2017-08-23 14:30:00'
UPDATE `hjxdb`.`user` SET `username`='apple', `cell_phone`=15811111111, `register_time`='2017-08-23 13:58:47', `school_code`=123, `email`='apple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=1 WHERE `username`='apple' AND `cell_phone`=12233334444 AND `register_time`='2017-08-23 13:58:47' AND `school_code`=123 AND `email`='apple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=1 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
UPDATE `hjxdb`.`user` SET `username`='pple', `cell_phone`=15811111111, `register_time`='2017-08-23 13:59:15', `school_code`=124, `email`='pple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=2 WHERE `username`='pple' AND `cell_phone`=12233334445 AND `register_time`='2017-08-23 13:59:15' AND `school_code`=124 AND `email`='pple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=2 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
UPDATE `hjxdb`.`user` SET `username`='ple', `cell_phone`=15811111111, `register_time`='2017-08-23 13:59:35', `school_code`=125, `email`='ple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=3 WHERE `username`='ple' AND `cell_phone`=12233334446 AND `register_time`='2017-08-23 13:59:35' AND `school_code`=125 AND `email`='ple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=3 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
UPDATE `hjxdb`.`user` SET `username`='le', `cell_phone`=15811111111, `register_time`='2017-08-23 13:59:52', `school_code`=126, `email`='le@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=4 WHERE `username`='le' AND `cell_phone`=12233334447 AND `register_time`='2017-08-23 13:59:52' AND `school_code`=126 AND `email`='le@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=4 LIMIT 1; #start 4166093 end 4166746 time 2017-08-23 14:02:09
USE mysql;
/* rds internal mark */ TRUNCATE TABLE mysql.slow_log;
INSERT INTO `hjxdb`.`user`(`username`, `cell_phone`, `register_time`, `school_code`, `email`, `usertype`, `state`, `password`, `id`) VALUES ('e', 12233334448, '2017-08-23 14:22:39', 127, 'e@123.com', 1, 2, 'hahaha', 5); #start 4197469 end 4197703 time 2017-08-23 14:22:39
UPDATE `hjxdb`.`user` SET `username`='apple', `cell_phone`=12233334444, `register_time`='2017-08-23 13:58:47', `school_code`=123, `email`='apple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=1 WHERE `username`='apple' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:58:47' AND `school_code`=123 AND `email`='apple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=1 LIMIT 1; #start 4201492 end 4201799 time 2017-08-23 14:25:13
UPDATE `hjxdb`.`user` SET `username`='pple', `cell_phone`=12233334445, `register_time`='2017-08-23 13:59:15', `school_code`=124, `email`='pple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=2 WHERE `username`='pple' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:59:15' AND `school_code`=124 AND `email`='pple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=2 LIMIT 1; #start 4201878 end 4202181 time 2017-08-23 14:25:13
UPDATE `hjxdb`.`user` SET `username`='ple', `cell_phone`=12233334446, `register_time`='2017-08-23 13:59:35', `school_code`=125, `email`='ple@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=3 WHERE `username`='ple' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:59:35' AND `school_code`=125 AND `email`='ple@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=3 LIMIT 1; #start 4202260 end 4202559 time 2017-08-23 14:25:13
UPDATE `hjxdb`.`user` SET `username`='le', `cell_phone`=12233334447, `register_time`='2017-08-23 13:59:52', `school_code`=126, `email`='le@123.com', `usertype`=1, `state`=2, `password`='hahaha', `id`=4 WHERE `username`='le' AND `cell_phone`=15811111111 AND `register_time`='2017-08-23 13:59:52' AND `school_code`=126 AND `email`='le@123.com' AND `usertype`=1 AND `state`=2 AND `password`='hahaha' AND `id`=4 LIMIT 1; #start 4202638 end 4202933 time 2017-08-23 14:25:13
```













