# A01-MySQL8.0安装

> 安装文档：<https://dev.mysql.com/doc/refman/8.0/en/installing.html>
>
> 数据目录：<https://dev.mysql.com/doc/refman/8.0/en/data-directory.html>
>
> 认证说明：<https://dev.mysql.com/doc/refman/8.0/en/creating-ssl-rsa-files-using-mysql.html>

## 下载并安装yum仓库

```shell
[root@qinxi Study]# wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
--2019-06-03 16:02:44--  https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
Resolving dev.mysql.com (dev.mysql.com)... 137.254.60.11
Saving to: ‘mysql80-community-release-el7-3.noarch.rpm’

100%[==========================================================>] 26,024      --.-K/s   in 0.09s   

2019-06-03 16:02:45 (286 KB/s) - ‘mysql80-community-release-el7-3.noarch.rpm’ saved [26024/26024]

[root@qinxi Study]# ll
total 48
-rw-r--r-- 1 root root 26024 Apr 25 02:29 mysql80-community-release-el7-3.noarch.rpm

[root@qinxi Study]# yum localinstall mysql80-community-release-el7-3.noarch.rpm 
Loaded plugins: fastestmirror
Examining mysql80-community-release-el7-3.noarch.rpm: mysql80-community-release-el7-3.noarch
Marking mysql80-community-release-el7-3.noarch.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package mysql80-community-release.noarch 0:el7-3 will be installed
--> Finished Dependency Resolution
Running transaction
  Installing : mysql80-community-release-el7-3.noarch                                           1/1 
  Verifying  : mysql80-community-release-el7-3.noarch                                           1/1 

Installed:
  mysql80-community-release.noarch 0:el7-3                                                          

Complete!



```

## 安装MySQL8.0

```shell
[root@qinxi Study]# yum repolist enabled | grep "mysql.*-community.*"
mysql-connectors-community/x86_64 MySQL Connectors Community                 108
mysql-tools-community/x86_64      MySQL Tools Community                       90
mysql80-community/x86_64          MySQL 8.0 Community Server                 113

[root@qinxi Study]# yum repolist all | grep mysql
mysql-cluster-7.5-community/x86_64 MySQL Cluster 7.5 Community   disabled
mysql-cluster-7.5-community-source MySQL Cluster 7.5 Community - disabled
mysql-cluster-7.6-community/x86_64 MySQL Cluster 7.6 Community   disabled
mysql-cluster-7.6-community-source MySQL Cluster 7.6 Community - disabled
mysql-cluster-8.0-community/x86_64 MySQL Cluster 8.0 Community   disabled
mysql-cluster-8.0-community-source MySQL Cluster 8.0 Community - disabled
mysql-connectors-community/x86_64  MySQL Connectors Community    enabled:    108
mysql-connectors-community-source  MySQL Connectors Community -  disabled
mysql-tools-community/x86_64       MySQL Tools Community         enabled:     90
mysql-tools-community-source       MySQL Tools Community - Sourc disabled
mysql-tools-preview/x86_64         MySQL Tools Preview           disabled
mysql-tools-preview-source         MySQL Tools Preview - Source  disabled
mysql55-community/x86_64           MySQL 5.5 Community Server    disabled
mysql55-community-source           MySQL 5.5 Community Server -  disabled
mysql56-community/x86_64           MySQL 5.6 Community Server    disabled
mysql56-community-source           MySQL 5.6 Community Server -  disabled
mysql57-community/x86_64           MySQL 5.7 Community Server    disabled
mysql57-community-source           MySQL 5.7 Community Server -  disabled
mysql80-community/x86_64           MySQL 8.0 Community Server    enabled:    113
mysql80-community-source           MySQL 8.0 Community Server -  disabled

[root@qinxi Study]# vim /etc/yum.repos.d/mysql-community.repo
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql80-community]
name=MySQL 8.0 Community Server
baseurl=http://repo.mysql.com/yum/mysql-8.0-community/el/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[root@qinxi ~]# yum install mysql-community-server
Loaded plugins: fastestmirror
base                                                                                                                                                                    | 3.6 kB  00:00:00     
epel                                                                                                                                                                    | 5.3 kB  00:00:00     
extras                                                                                                                                                                  | 3.4 kB  00:00:00     
mysql-connectors-community                                                                                                                                              | 2.5 kB  00:00:00     
mysql-tools-community                                                                                                                                                   | 2.5 kB  00:00:00     
mysql80-community                                                                                                                                                       | 2.5 kB  00:00:00     
updates                                                                                                                                                                 | 3.4 kB  00:00:00     
(1/2): epel/x86_64/updateinfo                                                                                                                                           | 977 kB  00:00:00     
(2/2): epel/x86_64/primary_db                                                                                                                                           | 6.7 MB  00:00:00     
Loading mirror speeds from cached hostfile
Resolving Dependencies
--> Running transaction check
---> Package mysql-community-server.x86_64 0:8.0.16-2.el7 will be installed
--> Processing Dependency: mysql-community-common(x86-64) = 8.0.16-2.el7 for package: mysql-community-server-8.0.16-2.el7.x86_64
--> Processing Dependency: mysql-community-client(x86-64) >= 8.0.11 for package: mysql-community-server-8.0.16-2.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: mysql-community-server-8.0.16-2.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.1)(64bit) for package: mysql-community-server-8.0.16-2.el7.x86_64
--> Processing Dependency: libaio.so.1()(64bit) for package: mysql-community-server-8.0.16-2.el7.x86_64
--> Running transaction check
---> Package libaio.x86_64 0:0.3.109-13.el7 will be installed
---> Package mysql-community-client.x86_64 0:8.0.16-2.el7 will be installed
--> Processing Dependency: mysql-community-libs(x86-64) >= 8.0.11 for package: mysql-community-client-8.0.16-2.el7.x86_64
---> Package mysql-community-common.x86_64 0:8.0.16-2.el7 will be installed
--> Running transaction check
---> Package mariadb-libs.x86_64 1:5.5.52-1.el7 will be obsoleted
--> Processing Dependency: libmysqlclient.so.18()(64bit) for package: 2:postfix-2.10.1-6.el7.x86_64
--> Processing Dependency: libmysqlclient.so.18(libmysqlclient_18)(64bit) for package: 2:postfix-2.10.1-6.el7.x86_64
---> Package mysql-community-libs.x86_64 0:8.0.16-2.el7 will be obsoleting
--> Running transaction check
---> Package mysql-community-libs-compat.x86_64 0:8.0.16-2.el7 will be obsoleting
---> Package postfix.x86_64 2:2.10.1-6.el7 will be updated
---> Package postfix.x86_64 2:2.10.1-7.el7 will be an update
--> Processing Dependency: libcrypto.so.10(OPENSSL_1.0.2)(64bit) for package: 2:postfix-2.10.1-7.el7.x86_64
--> Running transaction check
---> Package openssl-libs.x86_64 1:1.0.1e-60.el7_3.1 will be updated
--> Processing Dependency: openssl-libs(x86-64) = 1:1.0.1e-60.el7_3.1 for package: 1:openssl-1.0.1e-60.el7_3.1.x86_64
---> Package openssl-libs.x86_64 1:1.0.2k-16.el7_6.1 will be an update
--> Running transaction check
---> Package openssl.x86_64 1:1.0.1e-60.el7_3.1 will be updated
---> Package openssl.x86_64 1:1.0.2k-16.el7_6.1 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================================================================================
 Package                                                Arch                              Version                                           Repository                                    Size
===============================================================================================================================================================================================
Installing:
 mysql-community-libs                                   x86_64                            8.0.16-2.el7                                      mysql80-community                            3.0 M
     replacing  mariadb-libs.x86_64 1:5.5.52-1.el7
 mysql-community-libs-compat                            x86_64                            8.0.16-2.el7                                      mysql80-community                            2.1 M
     replacing  mariadb-libs.x86_64 1:5.5.52-1.el7
 mysql-community-server                                 x86_64                            8.0.16-2.el7                                      mysql80-community                            403 M
Installing for dependencies:
 libaio                                                 x86_64                            0.3.109-13.el7                                    base                                          24 k
 mysql-community-client                                 x86_64                            8.0.16-2.el7                                      mysql80-community                             32 M
 mysql-community-common                                 x86_64                            8.0.16-2.el7                                      mysql80-community                            575 k
Updating for dependencies:
 openssl                                                x86_64                            1:1.0.2k-16.el7_6.1                               updates                                      493 k
 openssl-libs                                           x86_64                            1:1.0.2k-16.el7_6.1                               updates                                      1.2 M
 postfix                                                x86_64                            2:2.10.1-7.el7                                    base                                         2.4 M

Transaction Summary
===============================================================================================================================================================================================
Install  3 Packages (+3 Dependent packages)
Upgrade             ( 3 Dependent packages)

Total size: 445 M
Is this ok [y/d/N]: y
Downloading packages:
warning: /var/cache/yum/x86_64/7/mysql80-community/packages/mysql-community-libs-8.0.16-2.el7.x86_64.rpm: Header V3 DSA/SHA1 Signature, key ID 5072e1f5: NOKEY
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
Importing GPG key 0x5072E1F5:
 Userid     : "MySQL Release Engineering <mysql-build@oss.oracle.com>"
 Fingerprint: a4a9 4068 76fc bd3c 4567 70c8 8c71 8d3b 5072 e1f5
 Package    : mysql80-community-release-el7-3.noarch (installed)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
Is this ok [y/N]: y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 1:openssl-libs-1.0.2k-16.el7_6.1.x86_64                                                                                                                                    1/13 
  Installing : mysql-community-common-8.0.16-2.el7.x86_64                                                                                                                                 2/13 
  Installing : mysql-community-libs-8.0.16-2.el7.x86_64                                                                                                                                   3/13 
  Installing : mysql-community-libs-compat-8.0.16-2.el7.x86_64                                                                                                                            4/13 
  Installing : mysql-community-client-8.0.16-2.el7.x86_64                                                                                                                                 5/13 
  Installing : libaio-0.3.109-13.el7.x86_64                                                                                                                                               6/13 
  Installing : mysql-community-server-8.0.16-2.el7.x86_64                                                                                                                                 7/13 
  Updating   : 2:postfix-2.10.1-7.el7.x86_64                                                                                                                                              8/13 
  Updating   : 1:openssl-1.0.2k-16.el7_6.1.x86_64                                                                                                                                         9/13 
  Cleanup    : 2:postfix-2.10.1-6.el7.x86_64                                                                                                                                             10/13 
  Erasing    : 1:mariadb-libs-5.5.52-1.el7.x86_64                                                                                                                                        11/13 
  Cleanup    : 1:openssl-1.0.1e-60.el7_3.1.x86_64                                                                                                                                        12/13 
  Cleanup    : 1:openssl-libs-1.0.1e-60.el7_3.1.x86_64                                                                                                                                   13/13 
  Verifying  : mysql-community-libs-8.0.16-2.el7.x86_64                                                                                                                                   1/13 
  Verifying  : mysql-community-libs-compat-8.0.16-2.el7.x86_64                                                                                                                            2/13 
  Verifying  : mysql-community-client-8.0.16-2.el7.x86_64                                                                                                                                 3/13 
  Verifying  : 2:postfix-2.10.1-7.el7.x86_64                                                                                                                                              4/13 
  Verifying  : 1:openssl-1.0.2k-16.el7_6.1.x86_64                                                                                                                                         5/13 
  Verifying  : mysql-community-common-8.0.16-2.el7.x86_64                                                                                                                                 6/13 
  Verifying  : 1:openssl-libs-1.0.2k-16.el7_6.1.x86_64                                                                                                                                    7/13 
  Verifying  : mysql-community-server-8.0.16-2.el7.x86_64                                                                                                                                 8/13 
  Verifying  : libaio-0.3.109-13.el7.x86_64                                                                                                                                               9/13 
  Verifying  : 1:openssl-1.0.1e-60.el7_3.1.x86_64                                                                                                                                        10/13 
  Verifying  : 1:mariadb-libs-5.5.52-1.el7.x86_64                                                                                                                                        11/13 
  Verifying  : 2:postfix-2.10.1-6.el7.x86_64                                                                                                                                             12/13 
  Verifying  : 1:openssl-libs-1.0.1e-60.el7_3.1.x86_64                                                                                                                                   13/13 

Installed:
  mysql-community-libs.x86_64 0:8.0.16-2.el7                  mysql-community-libs-compat.x86_64 0:8.0.16-2.el7                  mysql-community-server.x86_64 0:8.0.16-2.el7                 

Dependency Installed:
  libaio.x86_64 0:0.3.109-13.el7                        mysql-community-client.x86_64 0:8.0.16-2.el7                        mysql-community-common.x86_64 0:8.0.16-2.el7                       

Dependency Updated:
  openssl.x86_64 1:1.0.2k-16.el7_6.1                             openssl-libs.x86_64 1:1.0.2k-16.el7_6.1                             postfix.x86_64 2:2.10.1-7.el7                            

Replaced:
  mariadb-libs.x86_64 1:5.5.52-1.el7                                                                                                                                                           

Complete!

[root@qinxi ~]# find / -name '*mysql*'
/sys/fs/cgroup/systemd/system.slice/mysqld.service
/Study/mysql80-community-release-el7-3.noarch.rpm
/root/.mysql_history
/usr/sbin/mysqld-debug
/usr/sbin/mysqld
/usr/local/aegis/PythonLoader/third_party/pymysql
/usr/lib/tmpfiles.d/mysql.conf
/usr/lib/firewalld/services/mysql.xml
/usr/lib/systemd/system/mysqld.service
/usr/lib/systemd/system/mysqld@.service
/usr/lib64/mysql
/usr/lib64/mysql/libmysqlclient.so.18
/usr/lib64/mysql/libmysqlclient_r.so.18.1.0
/usr/lib64/mysql/libmysqlclient_r.so.18
/usr/lib64/mysql/plugin/debug/mysql_no_login.so
/usr/lib64/mysql/plugin/mysql_no_login.so
/usr/lib64/mysql/libmysqlclient.so.21
/usr/lib64/mysql/libmysqlclient.so.18.1.0
/usr/lib64/mysql/libmysqlclient.so.21.0.16
/usr/share/doc/mysql-community-server-8.0.16
/usr/share/doc/mysql-community-client-8.0.16
/usr/share/doc/mysql-community-libs-compat-8.0.16
/usr/share/doc/mysql-community-libs-8.0.16
/usr/share/doc/mysql-community-common-8.0.16
/usr/share/vim/vim74/syntax/mysql.vim
/usr/share/mysql-8.0
/usr/share/mysql-8.0/mysql-log-rotate
/usr/share/man/man8/mysqld.8.gz
/usr/share/man/man1/mysqldump.1.gz
/usr/share/man/man1/mysqlshow.1.gz
/usr/share/man/man1/mysql.server.1.gz
/usr/share/man/man1/mysql_upgrade.1.gz
/usr/share/man/man1/mysqlbinlog.1.gz
/usr/share/man/man1/mysqlman.1.gz
/usr/share/man/man1/mysqldumpslow.1.gz
/usr/share/man/man1/mysqlslap.1.gz
/usr/share/man/man1/mysqlimport.1.gz
/usr/share/man/man1/mysql_config_editor.1.gz
/usr/share/man/man1/mysql_secure_installation.1.gz
/usr/share/man/man1/mysqladmin.1.gz
/usr/share/man/man1/mysql_tzinfo_to_sql.1.gz
/usr/share/man/man1/mysqlcheck.1.gz
/usr/share/man/man1/mysqlpump.1.gz
/usr/share/man/man1/mysql_ssl_rsa_setup.1.gz
/usr/share/man/man1/mysql.1.gz
/usr/share/man/man5/mysql_table.5.gz
/usr/bin/mysqlcheck
/usr/bin/mysqld_pre_systemd
/usr/bin/mysqladmin
/usr/bin/mysqlimport
/usr/bin/mysql_tzinfo_to_sql
/usr/bin/mysql_upgrade
/usr/bin/mysqlbinlog
/usr/bin/mysqldump
/usr/bin/mysql_ssl_rsa_setup
/usr/bin/mysqlshow
/usr/bin/mysqlpump
/usr/bin/mysql
/usr/bin/mysql_secure_installation
/usr/bin/mysql_config_editor
/usr/bin/mysqlslap
/usr/bin/mysqldumpslow
/var/cache/yum/x86_64/7/mysql-tools-preview
/var/cache/yum/x86_64/7/mysql-connectors-community
/var/cache/yum/x86_64/7/mysql-cluster-7.5-community-source
/var/cache/yum/x86_64/7/mysql57-community
/var/cache/yum/x86_64/7/mysql-cluster-8.0-community-source
/var/cache/yum/x86_64/7/mysql-cluster-7.6-community
/var/cache/yum/x86_64/7/mysql-cluster-7.6-community-source
/var/cache/yum/x86_64/7/mysql55-community-source
/var/cache/yum/x86_64/7/mysql-cluster-8.0-community
/var/cache/yum/x86_64/7/mysql-connectors-community-source
/var/cache/yum/x86_64/7/mysql-tools-community
/var/cache/yum/x86_64/7/mysql80-community
/var/cache/yum/x86_64/7/mysql80-community-source
/var/cache/yum/x86_64/7/mysql56-community-source
/var/cache/yum/x86_64/7/mysql57-community-source
/var/cache/yum/x86_64/7/mysql56-community
/var/cache/yum/x86_64/7/mysql-tools-community-source
/var/cache/yum/x86_64/7/mysql-cluster-7.5-community
/var/cache/yum/x86_64/7/mysql-tools-preview-source
/var/cache/yum/x86_64/7/mysql55-community
/var/lib/mysql-files
/var/lib/mysql-keyring
/var/lib/yum/yumdb/m/a8bcc0d48150a9c50dc65647a3d4417ed16439d9-mysql-community-server-8.0.16-2.el7-x86_64
/var/lib/yum/yumdb/m/80db2b417564825770a2b99e800f646a1384c518-mysql-community-common-8.0.16-2.el7-x86_64
/var/lib/yum/yumdb/m/cd89c107439b72d113f0fad275b4c1b5fde74489-mysql80-community-release-el7-3-noarch
/var/lib/yum/yumdb/m/8e3309233cfe977ec90fce9f384243afe6b8314c-mysql-community-libs-8.0.16-2.el7-x86_64
/var/lib/yum/yumdb/m/6bb481272e6fa00a309553970ae28d1328f35b58-mysql-community-libs-compat-8.0.16-2.el7-x86_64
/var/lib/yum/yumdb/m/069f7e19971361b90d5c9fd1c6c0c967a3b6b7b3-mysql-community-client-8.0.16-2.el7-x86_64
/var/lib/yum/repos/x86_64/7/mysql-tools-preview
/var/lib/yum/repos/x86_64/7/mysql-connectors-community
/var/lib/yum/repos/x86_64/7/mysql-cluster-7.5-community-source
/var/lib/yum/repos/x86_64/7/mysql57-community
/var/lib/yum/repos/x86_64/7/mysql-cluster-8.0-community-source
/var/lib/yum/repos/x86_64/7/mysql-cluster-7.6-community
/var/lib/yum/repos/x86_64/7/mysql-cluster-7.6-community-source
/var/lib/yum/repos/x86_64/7/mysql55-community-source
/var/lib/yum/repos/x86_64/7/mysql-cluster-8.0-community
/var/lib/yum/repos/x86_64/7/mysql-connectors-community-source
/var/lib/yum/repos/x86_64/7/mysql-tools-community
/var/lib/yum/repos/x86_64/7/mysql80-community
/var/lib/yum/repos/x86_64/7/mysql80-community-source
/var/lib/yum/repos/x86_64/7/mysql56-community-source
/var/lib/yum/repos/x86_64/7/mysql57-community-source
/var/lib/yum/repos/x86_64/7/mysql56-community
/var/lib/yum/repos/x86_64/7/mysql-tools-community-source
/var/lib/yum/repos/x86_64/7/mysql-cluster-7.5-community
/var/lib/yum/repos/x86_64/7/mysql-tools-preview-source
/var/lib/yum/repos/x86_64/7/mysql55-community
/var/lib/mysql
/var/lib/mysql/mysql.ibd
/var/lib/mysql/mysql.sock
/var/lib/mysql/mysql
/var/lib/mysql/mysql.sock.lock
/var/log/mysqld.log
/run/mysqld
/run/mysqld/mysqlx.sock
/run/mysqld/mysqlx.sock.lock
/run/mysqld/mysqld.pid
/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
/etc/ld.so.conf.d/mysql-x86_64.conf
/etc/yum.repos.d/mysql-community.repo
/etc/yum.repos.d/mysql-community-source.repo
/etc/selinux/targeted/active/modules/100/mysql
/etc/logrotate.d/mysql
/etc/systemd/system/multi-user.target.wants/mysqld.service

# 配置文件
[root@qinxi ~]# cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove the leading "# " to disable binary logging
# Binary logging captures changes between backups and is enabled by
# default. It's default setting is log_bin=binlog
# disable_log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
#
# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
[root@qinxi ~]# 

# 数据目录
[root@qinxi ~]# cd /var/lib/mysql
[root@qinxi mysql]# ll
total 166988
-rw-r----- 1 mysql mysql       56 Jun  4 10:11 auto.cnf
-rw-r----- 1 mysql mysql      474 Jun  4 10:19 binlog.000001
-rw-r----- 1 mysql mysql       16 Jun  4 10:11 binlog.index
-rw------- 1 mysql mysql     1676 Jun  4 10:11 ca-key.pem
-rw-r--r-- 1 mysql mysql     1112 Jun  4 10:11 ca.pem
-rw-r--r-- 1 mysql mysql     1112 Jun  4 10:11 client-cert.pem
-rw------- 1 mysql mysql     1676 Jun  4 10:11 client-key.pem
-rw-r----- 1 mysql mysql     5752 Jun  4 10:11 ib_buffer_pool
-rw-r----- 1 mysql mysql 12582912 Jun  4 10:19 ibdata1
-rw-r----- 1 mysql mysql 50331648 Jun  4 10:19 ib_logfile0
-rw-r----- 1 mysql mysql 50331648 Jun  4 10:11 ib_logfile1
-rw-r----- 1 mysql mysql 12582912 Jun  4 10:11 ibtmp1
drwxr-x--- 2 mysql mysql     4096 Jun  4 10:11 #innodb_temp
drwxr-x--- 2 mysql mysql     4096 Jun  4 10:11 mysql
-rw-r----- 1 mysql mysql 24117248 Jun  4 10:19 mysql.ibd
srwxrwxrwx 1 mysql mysql        0 Jun  4 10:11 mysql.sock
-rw------- 1 mysql mysql        6 Jun  4 10:11 mysql.sock.lock
drwxr-x--- 2 mysql mysql     4096 Jun  4 10:11 performance_schema
-rw------- 1 mysql mysql     1676 Jun  4 10:11 private_key.pem
-rw-r--r-- 1 mysql mysql      452 Jun  4 10:11 public_key.pem
-rw-r--r-- 1 mysql mysql     1112 Jun  4 10:11 server-cert.pem
-rw------- 1 mysql mysql     1680 Jun  4 10:11 server-key.pem
drwxr-x--- 2 mysql mysql     4096 Jun  4 10:11 sys
-rw-r----- 1 mysql mysql 10485760 Jun  4 10:19 undo_001
-rw-r----- 1 mysql mysql 10485760 Jun  4 10:11 undo_002
[root@qinxi mysql]# 

[root@qinxi mysql]# du -sh *
4.0K	auto.cnf
4.0K	binlog.000001
4.0K	binlog.index
4.0K	ca-key.pem
4.0K	ca.pem
4.0K	client-cert.pem
4.0K	client-key.pem
8.0K	ib_buffer_pool
12M	ibdata1
48M	ib_logfile0
48M	ib_logfile1
12M	ibtmp1
228K	#innodb_temp
32K	mysql  #其中包含MySQL服务器运行时所需的信息。该数据库包含数据字典表和系统表
24M	mysql.ibd
0	mysql.sock
4.0K	mysql.sock.lock
1.4M	performance_schema #提供用于在运行时检查服务器内部执行的信息
4.0K	private_key.pem
4.0K	public_key.pem
4.0K	server-cert.pem
4.0K	server-key.pem
84K	sys #提供了一组对象，以帮助更轻松地解释性能模式信息
10M	undo_001
10M	undo_002


```

## 启动并修改密码MySQL8.0

```shell
[root@qinxi ~]# service mysqld start
Redirecting to /bin/systemctl start  mysqld.service

[root@qinxi ~]# service mysqld status
Redirecting to /bin/systemctl status  mysqld.service
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2019-06-04 10:11:24 CST; 33s ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 19796 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 19871 (mysqld)
   Status: "SERVER_OPERATING"
   CGroup: /system.slice/mysqld.service
           └─19871 /usr/sbin/mysqld

Jun 04 10:11:17 qinxi systemd[1]: Starting MySQL Server...
Jun 04 10:11:24 qinxi systemd[1]: Started MySQL Server.

[root@qinxi ~]# grep 'temporary password' /var/log/mysqld.log
2019-06-04T02:11:20.429811Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: ji,r8QaW1/%h

[root@qinxi ~]# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.16

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'AppleNewPass11!';

[root@qinxi ~]# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.16 MySQL Community Server - GPL

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

mysql> 

```

> 注意
>
> [`validate_password`](https://dev.mysql.com/doc/refman/8.0/en/validate-password.html) 默认安装。实现的默认密码策略`validate_password`要求密码包含至少一个大写字母，一个小写字母，一个数字和一个特殊字符，并且总密码长度至少为8个字符。

