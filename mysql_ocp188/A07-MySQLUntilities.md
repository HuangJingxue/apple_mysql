## MySQL Utilities

[TOC]



##　下载安装配置

```shell
# 下载安装
wget https://downloads.mysql.com/archives/get/file/mysql-utilities-1.6.5.tar.gz
tar zxvf  mysql-utilities-1.6.5.tar.gz
cd mysql-utilities-1.6.5
python ./setup.py build
sudo python ./setup.py install

# 安装后的命令即可
[root@Oracle01 mysql-utilities-1.6.5]# my
myisamchk                   mysqlbinlog                 mysqld                      mysqldumpslow               mysql_plugin                mysqlshow
myisam_ftdump               mysqlbinlogmove             mysqldbcompare              mysql_embedded              mysqlprocgrep               mysqlslap
myisamlog                   mysqlbinlogpurge            mysqldbcopy                 mysqlfailover               mysqlreplicate              mysqlslavetrx
myisampack                  mysqlbinlogrotate           mysqldbexport               mysql_find_rows             mysqlrpladmin               mysqltest
my_print_defaults           mysqlbug                    mysqldbimport               mysql_fix_extensions        mysqlrplcheck               mysqltest_embedded
mysql/                      mysqlcheck                  mysqld-debug                mysqlfrm                    mysqlrplms                  mysql_tzinfo_to_sql
mysqlaccess                 mysql_client_test           mysqldiff                   mysqlgrants                 mysqlrplshow                mysqluc
mysqlaccess.conf            mysql_client_test_embedded  mysqldiskusage              mysqlhotcopy                mysqlrplsync                mysql_upgrade
mysqladmin                  mysql_config                mysqld_multi                mysqlimport                 mysql_secure_installation   mysqluserclone
mysqlauditadmin             mysql_config_editor         mysqld_safe                 mysqlindexcheck             mysqlserverclone            mysql_waitpid
mysqlauditgrep              mysql_convert_table_format  mysqldump                   mysqlmetagrep               mysqlserverinfo  


```

## 生成加密账号密码
[mysql-config-editor](https://dev.mysql.com/doc/refman/8.0/en/mysql-config-editor.html)

```shell
[root@Oracle01 std_data]# mysql_config_editor --help
MySQL Configuration Utility.
Usage: mysql_config_editor [program options] [command [command options]]
  -?, --help          Display this help and exit.
  -v, --verbose       Write more information.
  -V, --version       Output version information and exit.

Variables (--variable-name=value)
and boolean options {FALSE|TRUE}  Value (after reading options)
--------------------------------- ----------------------------------------
verbose                           FALSE

Where command can be any one of the following :
       set [command options]     Sets user name/password/host name/socket/port
                                 for a given login path (section).
       remove [command options]  Remove a login path from the login file.
       print [command options]   Print all the options for a specified
                                 login path.
       reset [command options]   Deletes the contents of the login file.
       help                      Display this usage/help information.

[root@Oracle01 std_data]# mysql_config_editor reset
[root@Oracle01 std_data]# mysql_config_editor print --all

[root@Oracle01 std_data]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.6.45-enterprise-commercial-advanced-log MySQL Enterprise Server - Advanced Edition (Commercial)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create user 'apple'@'localhost' identified by 'apple123';
Query OK, 0 rows affected (0.00 sec)

mysql> grant all on *.* to apple@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> set password for 'root'@'localhost' = password('root123');
Query OK, 0 rows affected (0.01 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)

mysql> exit
Bye

[root@Oracle01 std_data]# mysql_config_editor set --login-path=client --host=localhost --user=apple --password
Enter password: 
[root@Oracle01 std_data]# mysql_config_editor print --all
[client]
user = apple
password = *****
host = localhost
[root@Oracle01 std_data]# mysql --login-path=client
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.6.45-enterprise-commercial-advanced-log MySQL Enterprise Server - Advanced Edition (Commercial)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> exit
Bye

# 获取到数据库的基本信息
[root@Oracle01 std_data]# mysqlserverinfo --server=client --format=vertical
# Source on localhost: ... connected.
*************************       1. row *************************
                   server: localhost:3306
              config_file: /etc/my.cnf, /alidata/mysql/my.cnf
               binary_log: mybinlog.000007
           binary_log_pos: 984
                relay_log: 
            relay_log_pos: 
                  version: 5.6.45-enterprise-commercial-advanced-log
                  datadir: /alidata/mysql/data/
                  basedir: /alidata/mysql/
               plugin_dir: /alidata/mysql/lib/plugin/
              general_log: OFF
         general_log_file: 
    general_log_file_size: 
                log_error: /alidata/mysql/data/error.log
      log_error_file_size: 31091 bytes
           slow_query_log: ON
      slow_query_log_file: /alidata/mysql/data/slow.log
 slow_query_log_file_size: 1200 bytes
1 row.
#...done.
```

## 识别潜在的冗余表索引

[mysqlindexcheck](https://docs.oracle.com/cd/E17952_01/mysql-utilities-1.4-en/mysqlindexcheck.html)

```shell
CREATE TABLE `qinxi`.`indexcheck_test`(
       `emp_id` INT(11) NOT NULL,
       `fiscal_number` int(11) NOT NULL,
       `name` VARCHAR(50) NOT NULL,
       `surname` VARCHAR (50) NOT NULL,
       `job_title` VARCHAR (20),
       `hire_date` DATE default NULL,
       `birthday` DATE default NULL,
       PRIMARY KEY (`emp_id`),
       KEY `idx_fnumber`(`fiscal_number`),
       UNIQUE KEY `idx_unifnumber` (`fiscal_number`),
       UNIQUE KEY `idx_uemp_id` (`emp_id`),
       KEY `idx_full_name` (`name`, `surname`),
       KEY `idx_full_name_dup` (`name`, `surname`),
       KEY `idx_name` (`name`),
       KEY `idx_surname` (`surname`),
       KEY `idx_reverse_name` (`surname`,`name`),
       KEY `ìdx_id_name` (`emp_id`, `name`),
       KEY `idx_id_hdate` (`emp_id`, `hire_date`),
       KEY `idx_id_bday` (`emp_id`, `birthday`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;      


CREATE UNIQUE INDEX `idx_uemp_id` ON `qinxi`.`indexcheck_test` (`emp_id`) USING BTREE
#     may be redundant or duplicate of:
ALTER TABLE `qinxi`.`indexcheck_test` ADD PRIMARY KEY (`emp_id`)
#
CREATE INDEX `idx_fnumber` ON `qinxi`.`indexcheck_test` (`fiscal_number`) USING BTREE
#     may be redundant or duplicate of:
CREATE UNIQUE INDEX `idx_unifnumber` ON `qinxi`.`indexcheck_test` (`fiscal_number`) USING BTREE
#
CREATE INDEX `idx_full_name_dup` ON `qinxi`.`indexcheck_test` (`name`, `surname`) USING BTREE
#     may be redundant or duplicate of:
CREATE INDEX `idx_full_name` ON `qinxi`.`indexcheck_test` (`name`, `surname`) USING BTREE
#
CREATE INDEX `idx_name` ON `qinxi`.`indexcheck_test` (`name`) USING BTREE
#     may be redundant or duplicate of:
CREATE INDEX `idx_full_name` ON `qinxi`.`indexcheck_test` (`name`, `surname`) USING BTREE
#
CREATE INDEX `idx_surname` ON `qinxi`.`indexcheck_test` (`surname`) USING BTREE
#     may be redundant or duplicate of:
CREATE INDEX `idx_reverse_name` ON `qinxi`.`indexcheck_test` (`surname`, `name`) USING BTREE
#
CREATE INDEX `ìdx_id_name` ON `qinxi`.`indexcheck_test` (`emp_id`, `name`) USING BTREE
#     may be redundant or duplicate of:
ALTER TABLE `qinxi`.`indexcheck_test` ADD PRIMARY KEY (`emp_id`)
#
CREATE INDEX `idx_id_hdate` ON `qinxi`.`indexcheck_test` (`emp_id`, `hire_date`) USING BTREE
#     may be redundant or duplicate of:
ALTER TABLE `qinxi`.`indexcheck_test` ADD PRIMARY KEY (`emp_id`)
#
CREATE INDEX `idx_id_bday` ON `qinxi`.`indexcheck_test` (`emp_id`, `birthday`) USING BTREE
#     may be redundant or duplicate of:
ALTER TABLE `qinxi`.`indexcheck_test` ADD PRIMARY KEY (`emp_id`)
# The following indexes for table qinxi.indexcheck_test contain the clustered index and might be redundant:
#
CREATE UNIQUE INDEX `idx_uemp_id` ON `qinxi`.`indexcheck_test` (`emp_id`) USING BTREE
#
CREATE INDEX `ìdx_id_name` ON `qinxi`.`indexcheck_test` (`emp_id`, `name`) USING BTREE
#
CREATE INDEX `idx_id_hdate` ON `qinxi`.`indexcheck_test` (`emp_id`, `hire_date`) USING BTREE
#
CREATE INDEX `idx_id_bday` ON `qinxi`.`indexcheck_test` (`emp_id`, `birthday`) USING BTREE

```

[mysqladmin]()

```shell
[root@Oracle01 install]# mysqlrpladmin --master=failover:pass@'192.168.206.131':3306  --new-master=failover:pass@'192.168.206.132':3306 --demote-master --slave=failover:pass@'192.168.206.132':3306 switchover
WARNING: Using a password on the command line interface can be insecure.
# Checking privileges.
# WARNING: You may be mixing host names and IP addresses. This may result in negative status reporting if your DNS services do not support reverse name lookup.
# Performing switchover from master at 192.168.206.131:3306 to slave at 192.168.206.132:3306.
# Checking candidate slave prerequisites.
Candidate is not connected to the correct master.
ERROR: Candidate is not connected to the correct master.
# Errors found. Switchover aborted.
#
# Replication Topology Health:
+------------------+-------+---------+--------+------------+------------------------------------+
| host             | port  | role    | state  | gtid_mode  | health                             |
+------------------+-------+---------+--------+------------+------------------------------------+
| 192.168.206.131  | 3306  | MASTER  | UP     | ON         | OK                                 |
| 192.168.206.132  | 3306  | SLAVE   | WARN   |            | Slave is not connected to master.  |
+------------------+-------+---------+--------+------------+------------------------------------+
# ...done
```

## 主从监控并切换

[mysqlfailover](https://docs.oracle.com/cd/E17952_01/mysql-utilities-1.4-en/mysqlfailover.html)

```shell
1、两个实例安装好
2、授权
# 主从节点都执行
grant create,insert,drop,select,super,replication slave,reload on *.* to repm@192.168.206.131 identified by '123' with grant option;
grant create,insert,drop,select,super,replication slave,reload on *.* to repm@192.168.206.134 identified by '123' with grant option;
3、主从配置
# 主节点执行
[root@Oracle01 ~]# mysqlreplicate --master=repm:123@'192.168.206.131':3306  --slave=repm:123@'192.168.206.134':3306 --rpl-user=repm:123
WARNING: Using a password on the command line interface can be insecure.
# master on 192.168.206.131: ... connected.
# slave on 192.168.206.134: ... connected.
# Checking for binary logging on master...
# Setting up replication...
# ...done.

# 从节点查看到以下内容
mysql> show slave status\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.206.131
                  Master_User: repm
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mybinlog.000001
          Read_Master_Log_Pos: 151
               Relay_Log_File: mysqldb-relay-bin.000002
                Relay_Log_Pos: 359
        Relay_Master_Log_File: mybinlog.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 151
              Relay_Log_Space: 565
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 3
                  Master_UUID: 04591d7a-df42-11e9-92af-000c29047127
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 1
1 row in set (0.00 sec)

ERROR: 
No query specified

至此主从通过mysqlreplicat搭建成功


4、监控配置
#主节点执行
[root@Oracle01 tmp]# mysqlfailover --master=repm:123@'192.168.206.131':3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log --failover-mode=auto --daemon=start

#从节点执行
[root@Oracle01 ~]# mysqlfailover --master=repm:123@'192.168.206.131':3306 --slave=repm:123@'192.168.206.134':3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log  --daemon=start


详情如下：
#主节点执行
[root@Oracle01 tmp]# mysqlfailover --master=repm:123@'192.168.206.131':3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log --failover-mode=auto --daemon=start
WARNING: Using a password on the command line interface can be insecure.
Starting failover daemon...

[root@Oracle01 ~]# ps -ef | grep mysqlfailover
root       1043      1  0 14:33 ?        00:00:00 /usr/bin/python /usr/bin/mysqlfailover --master=repm:123@192.168.206.131:3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log --failover-mode=auto --daemon=start
root       1962 130182  0 14:37 pts/4    00:00:00 grep --color=auto mysqlfailover


当监控进程开启时，failover=fail状态时非指定状态，可以通过强制重启即可恢复 --force
[root@Oracle01 ~]# mysqlfailover --master=repm:123@'192.168.206.131':3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log --daemon=start
WARNING: Using a password on the command line interface can be insecure.
Starting failover daemon...
Multiple instances of failover daemon found for master 192.168.206.131:3306.
If this is an error, restart the daemon with --force.
Failover mode changed to 'FAIL' for this instance.
Daemon will start in 10 seconds.
.........starting Daemon.

日志内容
2019-10-16 14:32:49 PM INFO Discovering slave at 192.168.206.134:3306
2019-10-16 14:32:49 PM INFO Found slave: 192.168.206.134:3306
2019-10-16 14:32:49 PM INFO Server '192.168.206.134:3306' is using MySQL version 5.6.45-enterprise-commercial-advanced-log.
2019-10-16 14:32:49 PM INFO Checking privileges.
2019-10-16 14:32:49 PM INFO Unregistering existing instances from slaves.
2019-10-16 14:32:49 PM INFO Registering instance on master.
2019-10-16 14:32:49 PM WARNING Multiple instances of failover daemon found for master 192.168.206.131:3306.
2019-10-16 14:32:59 PM INFO Failover daemon started.
2019-10-16 14:32:59 PM INFO Failover mode = fail.
2019-10-16 14:33:02 PM INFO Master Information
2019-10-16 14:33:02 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 14:33:02 PM INFO GTID Executed Set: None
2019-10-16 14:33:02 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 14:33:02 PM INFO Health Status:
2019-10-16 14:33:02 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 14:33:02 PM INFO host: 192.168.206.134, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK

# 解决方式
[root@Oracle01 ~]# mysqlfailover --master=repm:123@'192.168.206.131':3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log --force --daemon=restart
WARNING: Using a password on the command line interface can be insecure.
Restarting failover daemon...

# 解决后日志内容
2019-10-16 14:45:38 PM INFO Discovering slave at 192.168.206.134:3306
2019-10-16 14:45:38 PM INFO Found slave: 192.168.206.134:3306
2019-10-16 14:45:38 PM INFO Server '192.168.206.134:3306' is using MySQL version 5.6.45-enterprise-commercial-advanced-log.
2019-10-16 14:45:38 PM INFO Unregistering instance on master.
2019-10-16 14:45:38 PM INFO Failover daemon stopped.
2019-10-16 14:45:38 PM INFO Checking privileges.
2019-10-16 14:45:38 PM INFO Unregistering existing instances from slaves.
2019-10-16 14:45:38 PM INFO Registering instance on master.
2019-10-16 14:45:38 PM INFO Failover daemon started.
2019-10-16 14:45:38 PM INFO Failover mode = auto.
2019-10-16 14:45:41 PM INFO Master Information
2019-10-16 14:45:41 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 14:45:41 PM INFO GTID Executed Set: None
2019-10-16 14:45:41 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 14:45:41 PM INFO Health Status:
2019-10-16 14:45:41 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 14:45:41 PM INFO host: 192.168.206.134, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK




# 从节点执行
[root@Oracle01 ~]# mysqlfailover --master=repm:123@'192.168.206.131':3306 --slave=repm:123@'192.168.206.134':3306 --discover-slaves-login=repm:123 --log=/tmp/failover.log  --daemon=start
WARNING: Using a password on the command line interface can be insecure.

# 从节点日志内容
2019-10-16 14:52:19 PM INFO MySQL Utilities mysqlfailover version 1.6.5.
2019-10-16 14:52:19 PM INFO Server '192.168.206.131:3306' is using MySQL version 5.6.45-enterprise-commercial-advanced-log.
2019-10-16 14:52:19 PM INFO Server '192.168.206.134:3306' is using MySQL version 5.6.45-enterprise-commercial-advanced-log.
2019-10-16 14:52:19 PM INFO Discovering slaves for master at 192.168.206.131:3306
2019-10-16 14:53:09 PM INFO Discovering slave at 192.168.206.134:3306
2019-10-16 14:53:09 PM INFO Checking privileges.
2019-10-16 14:53:09 PM INFO Unregistering existing instances from slaves.
2019-10-16 14:53:09 PM INFO Registering instance on master.
2019-10-16 14:53:09 PM WARNING Multiple instances of failover daemon found for master 192.168.206.131:3306.
2019-10-16 14:53:19 PM INFO Failover daemon started.
2019-10-16 14:53:19 PM INFO Failover mode = fail.
2019-10-16 14:53:22 PM INFO Master Information
2019-10-16 14:53:22 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 14:53:22 PM INFO GTID Executed Set: None
2019-10-16 14:53:22 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 14:53:22 PM INFO Health Status:
2019-10-16 14:53:22 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 14:53:22 PM INFO host: 192.168.206.134, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK
====================================================================================================================
当监控进程开启时，failover=fail状态时非指定状态，可以通过强制重启即可恢复 --force
2019-10-16 15:09:23 PM INFO Discovering slave at 192.168.206.134:3306
2019-10-16 15:09:23 PM INFO Unregistering instance on master.
2019-10-16 15:09:23 PM INFO Failover daemon stopped.
2019-10-16 15:09:23 PM INFO Checking privileges.
2019-10-16 15:09:23 PM INFO Unregistering existing instances from slaves.
2019-10-16 15:09:23 PM INFO Registering instance on master.
2019-10-16 15:09:23 PM INFO Failover daemon started.
2019-10-16 15:09:23 PM INFO Failover mode = auto.
2019-10-16 15:09:26 PM INFO Master Information
2019-10-16 15:09:26 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:09:26 PM INFO GTID Executed Set: None
2019-10-16 15:09:26 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 15:09:26 PM INFO Health Status:
2019-10-16 15:09:26 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:09:26 PM INFO host: 192.168.206.134, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK

5、主宕机模拟（检测，切换主从）
# 当前时间2019-10-16 15：10 模拟主库宕机
[root@Oracle01 ~]# /etc/init.d/mysqld stop
Shutting down MySQL............ SUCCESS! 

# 主库监控日志
2019-10-16 15:10:26 PM INFO Discovering slaves for master at 192.168.206.131:3306
2019-10-16 15:10:26 PM INFO Discovering slave at 192.168.206.134:3306
2019-10-16 15:10:26 PM INFO Master Information
2019-10-16 15:10:26 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:10:26 PM INFO GTID Executed Set: None
2019-10-16 15:10:26 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 15:10:26 PM INFO Health Status:
2019-10-16 15:10:26 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:10:26 PM INFO host: 192.168.206.134, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK
=====================================================================================================================
#每15秒检测一次，检测3次则认为主挂了
2019-10-16 15:10:50 PM INFO Master may be down. Waiting for 3 seconds.
2019-10-16 15:11:05 PM INFO Failed to reconnect to the master after 3 attempts.
2019-10-16 15:11:05 PM CRITICAL Master is confirmed to be down or unreachable.
2019-10-16 15:11:05 PM INFO Failover starting in 'auto' mode...
2019-10-16 15:11:05 PM INFO Candidate slave 192.168.206.134:3306 will become the new master.
2019-10-16 15:11:05 PM INFO Checking slaves status (before failover).
2019-10-16 15:11:05 PM INFO Preparing candidate for failover.
2019-10-16 15:11:55 PM INFO Creating replication user if it does not exist.
2019-10-16 15:11:55 PM INFO Stopping slaves.
2019-10-16 15:11:55 PM INFO Performing STOP on all slaves.
2019-10-16 15:13:05 PM INFO Switching slaves to new master.
2019-10-16 15:13:05 PM INFO Disconnecting new master as slave.
2019-10-16 15:13:05 PM INFO Starting slaves.
2019-10-16 15:13:05 PM INFO Performing START on all slaves.
2019-10-16 15:13:05 PM INFO Checking slaves for errors.
2019-10-16 15:13:05 PM INFO Failover complete.
2019-10-16 15:13:05 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:13:10 PM INFO Unregistering existing instances from slaves.
2019-10-16 15:13:10 PM INFO Registering instance on new master 192.168.206.134:3306.
2019-10-16 15:13:11 PM INFO Master Information
2019-10-16 15:13:11 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:13:11 PM INFO GTID Executed Set: None
2019-10-16 15:13:11 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:13:11 PM INFO Health Status:
2019-10-16 15:13:11 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:13:29 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:13:29 PM INFO Master Information
2019-10-16 15:13:29 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:13:29 PM INFO GTID Executed Set: None
2019-10-16 15:13:29 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:13:29 PM INFO Health Status:
2019-10-16 15:13:29 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:13:47 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:13:47 PM INFO Master Information
2019-10-16 15:13:47 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:13:47 PM INFO GTID Executed Set: None
2019-10-16 15:13:47 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:13:47 PM INFO Health Status:
2019-10-16 15:13:47 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:14:05 PM INFO Discovering slaves for master at 192.168.206.134:3306


# 从库监控日志
2019-10-16 15:10:21 PM INFO Health Status:
2019-10-16 15:10:21 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:10:21 PM INFO host: 192.168.206.134, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK
=================================================================================================================
2019-10-16 15:10:48 PM INFO Failed to reconnect to the master after 3 attempts.
2019-10-16 15:10:48 PM CRITICAL Master is confirmed to be down or unreachable.
2019-10-16 15:10:48 PM INFO Failover starting in 'auto' mode...
2019-10-16 15:10:48 PM INFO Candidate slave 192.168.206.134:3306 will become the new master.
2019-10-16 15:10:48 PM INFO Checking slaves status (before failover).
2019-10-16 15:10:48 PM INFO Preparing candidate for failover.
2019-10-16 15:11:58 PM INFO Creating replication user if it does not exist.
2019-10-16 15:11:58 PM INFO Stopping slaves.
2019-10-16 15:11:58 PM INFO Performing STOP on all slaves.
2019-10-16 15:13:08 PM INFO Switching slaves to new master.
2019-10-16 15:13:08 PM INFO Disconnecting new master as slave.
2019-10-16 15:13:08 PM INFO Starting slaves.
2019-10-16 15:13:08 PM INFO Performing START on all slaves.
2019-10-16 15:13:08 PM INFO Checking slaves for errors.
2019-10-16 15:13:08 PM INFO Failover complete.
2019-10-16 15:13:08 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:13:13 PM INFO Unregistering existing instances from slaves.
2019-10-16 15:13:13 PM INFO Registering instance on new master 192.168.206.134:3306.
2019-10-16 15:13:13 PM INFO Master Information
2019-10-16 15:13:13 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:13:13 PM INFO GTID Executed Set: None
2019-10-16 15:13:13 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:13:13 PM INFO Health Status:
2019-10-16 15:13:13 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:13:31 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:13:31 PM INFO Master Information
2019-10-16 15:13:31 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:13:31 PM INFO GTID Executed Set: None
2019-10-16 15:13:31 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:13:31 PM INFO Health Status:
2019-10-16 15:13:31 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:13:49 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:13:49 PM INFO Master Information
2019-10-16 15:13:49 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:13:49 PM INFO GTID Executed Set: None
2019-10-16 15:13:49 PM INFO Getting health for master: 192.168.206.134:3306.
==========================================================================
检测到主宕机了，将从提升为主
mysql> show slave status\G;
Empty set (0.00 sec)

ERROR: 
No query specified

此时主从监控还在正常运行
6、原来主启动 （重搭主从/主实例开启监控）
# 原来主执行
[root@Oracle01 ~]# /etc/init.d/mysqld start
Starting MySQL... SUCCESS! 
=============================================================
主从并未自动搭建，需要手动重新搭建
# 主节点执行
[root@Oracle01 ~]# mysqlreplicate --master=repm:123@'192.168.206.134':3306  --slave=repm:123@'192.168.206.131':3306 --rpl-user=repm:123
WARNING: Using a password on the command line interface can be insecure.
# master on 192.168.206.134: ... connected.
# slave on 192.168.206.131: ... connected.
# Checking for binary logging on master...
# Setting up replication...
# ...done.

# 原来的主监控日志
2019-10-16 15:52:55 PM INFO Master Information
2019-10-16 15:52:55 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:52:55 PM INFO GTID Executed Set: None
2019-10-16 15:52:55 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:52:55 PM INFO Health Status:
2019-10-16 15:52:55 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:52:55 PM INFO host: 192.168.206.131, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK

# 当前的主监控
2019-10-16 15:53:33 PM INFO Discovering slaves for master at 192.168.206.134:3306
2019-10-16 15:53:33 PM INFO Discovering slave at 192.168.206.131:3306
2019-10-16 15:53:33 PM INFO Master Information
2019-10-16 15:53:33 PM INFO Binary Log File: mybinlog.000001, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:53:33 PM INFO GTID Executed Set: None
2019-10-16 15:53:33 PM INFO Getting health for master: 192.168.206.134:3306.
2019-10-16 15:53:33 PM INFO Health Status:
2019-10-16 15:53:33 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:53:33 PM INFO host: 192.168.206.131, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK

7、将当前的主模拟宕机
# 2019-10-16 15：54 手动停止
[root@Oracle01 ~]# /etc/init.d/mysqld stop
Shutting down MySQL............. SUCCESS!
=====================================================================================
2019-10-16 15:54:15 PM INFO Master may be down. Waiting for 3 seconds.
2019-10-16 15:54:30 PM INFO Failed to reconnect to the master after 3 attempts.
2019-10-16 15:54:30 PM CRITICAL Master is confirmed to be down or unreachable.
2019-10-16 15:54:30 PM CRITICAL Master has failed and automatic failover is not enabled. Check server for errors and run the mysqlrpladmin utility to perform manual failover.
2019-10-16 15:54:30 PM INFO Unregistering instance on master.
2019-10-16 15:54:30 PM INFO Failover daemon stopped.

从库监控日志
2019-10-16 15:53:50 PM INFO host: 192.168.206.134, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:53:50 PM INFO host: 192.168.206.131, port: 3306, role: SLAVE, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:54:17 PM INFO Failed to reconnect to the master after 3 attempts.
2019-10-16 15:54:17 PM CRITICAL Master is confirmed to be down or unreachable.
2019-10-16 15:54:17 PM INFO Failover starting in 'auto' mode...
2019-10-16 15:54:17 PM INFO Candidate slave 192.168.206.131:3306 will become the new master.
2019-10-16 15:54:17 PM INFO Checking slaves status (before failover).
2019-10-16 15:54:17 PM INFO Preparing candidate for failover.
2019-10-16 15:55:27 PM INFO Creating replication user if it does not exist.
2019-10-16 15:55:27 PM INFO Stopping slaves.
2019-10-16 15:55:27 PM INFO Performing STOP on all slaves.
2019-10-16 15:56:37 PM INFO Switching slaves to new master.
2019-10-16 15:56:37 PM INFO Disconnecting new master as slave.
2019-10-16 15:56:37 PM INFO Starting slaves.
2019-10-16 15:56:37 PM INFO Performing START on all slaves.
2019-10-16 15:56:37 PM INFO Checking slaves for errors.
2019-10-16 15:56:37 PM INFO Failover complete.
2019-10-16 15:56:37 PM INFO Discovering slaves for master at 192.168.206.131:3306
2019-10-16 15:56:42 PM INFO Unregistering existing instances from slaves.
2019-10-16 15:56:42 PM INFO Registering instance on new master 192.168.206.131:3306.
2019-10-16 15:56:42 PM INFO Master Information
2019-10-16 15:56:42 PM INFO Binary Log File: mybinlog.000002, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:56:42 PM INFO GTID Executed Set: None
2019-10-16 15:56:42 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 15:56:42 PM INFO Health Status:
2019-10-16 15:56:42 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:57:00 PM INFO Discovering slaves for master at 192.168.206.131:3306
2019-10-16 15:57:00 PM INFO Master Information
2019-10-16 15:57:00 PM INFO Binary Log File: mybinlog.000002, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:57:00 PM INFO GTID Executed Set: None
2019-10-16 15:57:00 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 15:57:00 PM INFO Health Status:
2019-10-16 15:57:00 PM INFO host: 192.168.206.131, port: 3306, role: MASTER, state: UP, gtid_mode: ON, health: OK
2019-10-16 15:57:18 PM INFO Discovering slaves for master at 192.168.206.131:3306
2019-10-16 15:57:18 PM INFO Master Information
2019-10-16 15:57:18 PM INFO Binary Log File: mybinlog.000002, Position: 151, Binlog_Do_DB: N/A, Binlog_Ignore_DB: N/A
2019-10-16 15:57:18 PM INFO GTID Executed Set: None
2019-10-16 15:57:18 PM INFO Getting health for master: 192.168.206.131:3306.
2019-10-16 15:57:18 PM INFO Health Status:


至此又回到文章最开头状态，192.168.206.131为主状态。如果重复该操作，重建主从，将从节点监控重新开启即可。

注意点：
再次开启从节点监控，mysqlfailover 需添加上--force参数。否则是fail模式，只能监控，无法切换

```
# show slave hosts异常
```sql
# 在主库当中查看的从库信息，不是想要的。192.168.206.132 应该显示为192.168.206.134
[root@Oracle01 ~]# mysql -uroot -proot123
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 484
Server version: 5.6.45-enterprise-commercial-advanced-log MySQL Enterprise Server - Advanced Edition (Commercial)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show slave hosts;
+-----------+-----------------+------+-----------+--------------------------------------+
| Server_id | Host            | Port | Master_id | Slave_UUID                           |
+-----------+-----------------+------+-----------+--------------------------------------+
|         4 | 192.168.206.132 | 3306 |         3 | 04591d7a-df42-11e9-92af-000c29047128 |
+-----------+-----------------+------+-----------+--------------------------------------+
1 row in set (0.00 sec)

# 到从库当中执行以下操作
mysql> show variables like 'report%';
+-----------------+-----------------+
| Variable_name   | Value           |
+-----------------+-----------------+
| report_host     | 192.168.206.132 |
| report_password |                 |
| report_port     | 3306            |
| report_user     |                 |
+-----------------+-----------------+
4 rows in set (0.00 sec)

# 从库的配置文件修改参数report_host
report_host=192.168.206.134
report_port=3306


# 重启从库实例后，查看主库信息
mysql> show slave hosts;
+-----------+-----------------+------+-----------+--------------------------------------+
| Server_id | Host            | Port | Master_id | Slave_UUID                           |
+-----------+-----------------+------+-----------+--------------------------------------+
|         4 | 192.168.206.132 | 3306 |         3 | 04591d7a-df42-11e9-92af-000c29047128 |
+-----------+-----------------+------+-----------+--------------------------------------+
1 row in set (0.00 sec)

```

## 解析frm文件

[mysqlfrm](https://docs.oracle.com/cd/E17952_01/mysql-utilities-1.4-en/mysqlfrm.html)
```sql
[root@build-center alidata]# /etc/init.d/mysqld stop
Shutting down MySQL..                                      [  OK  ]
[root@build-center alidata]# mysqlfrm --diagnostic /alidata/mysql/data/booboo/
# WARNING: Cannot generate character set or collation names without the --server option.
# CAUTION: The diagnostic mode is a best-effort parse of the .frm file. As such, it may not identify all of the components of the table correctly. This is especially true for damaged files. It will also not read the default values for the columns and the resulting statement may not be syntactically correct.
# Reading .frm file for /alidata/mysql/data/booboo/qinxi.frm:
# The .frm file is a TABLE.
# CREATE TABLE Statement:

CREATE TABLE `booboo`.`qinxi` (
  `id` int(11) DEFAULT NULL, 
  `name` varchar(200) DEFAULT NULL 
) ENGINE=InnoDB;

# Reading .frm file for /alidata/mysql/data/booboo/qinxi1.frm:
# The .frm file is a TABLE.
# CREATE TABLE Statement:

CREATE TABLE `booboo`.`qinxi1` (
  `id` int(11) NOT NULL, 
  `col` int(11) NOT NULL, 
PRIMARY KEY `PRIMARY` (`id`,`col`)
) ENGINE=INNODB  PARTITION BY RANGE (col) (PARTITION p1 VALUES LESS THAN (10) ENGINE = InnoDB,  PARTITION p2 VALUES LESS THAN (20) ENGINE = InnoDB);

#...done.

```

