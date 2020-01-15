#!/usr/bin/bash
#2019-08-01 QINXI:CREATE
#2019-08-02 QINXI:V1.1.0


#填写损坏实例信息
old_host=127.0.0.1
old_username=root
old_userpwd=
old_datadir=/home/my3308/data
old_port=3308
databases=`mysql -u$old_username -p$old_userpwd -h$old_host -P$old_port -e"show databases;"|grep -Ev 'test|Database|information_schema|performance_schema|mysql|tmp|sys|hash*'`
#首先获取健康的ddl文件
#mysqldump -h127.0.0.1  -P3308 -uroot --opt --set-gtid-purged=OFF --default-character-set=utf8  --single-transaction --hex-blob --skip-triggers --max_allowed_packet=824288000 -d xcrm_wxsn_0016 > xcrm_wxsn_0016.sql
#填写新创建实例信息
dumpdir=/home
sequencefile=sequence.sql
host=127.0.0.1
username=root
userpwd=
port=3309
new_datadir=/home/my3309/data

for database in $databases
do  
     `mysqldump -u$old_username -p$old_userpwd -h$old_host -P$old_port --opt --set-gtid-purged=OFF --default-character-set=utf8  --single-transaction --hex-blob --skip-triggers --max_allowed_packet=824288000 -d $database > $dumpdir/$database.sql`
    `mysql -u$username -h$host -P$port -A -Bse "create database $database"`
    `mysql -u$username -h$host -P$port  $database < $dumpdir/$database.sql`
    tables=`mysql -u$username -h$host -P$port  $database -A -Bse "show tables"`
        for table in $tables
        do
            #数据与结构分离
           `mysql -u$username -h$host -P$port $database -A -Bse "ALTER TABLE $table DISCARD TABLESPACE";`
            old_ibdfile=$old_datadir/$database/$table.ibd
            new_ibddir=$new_datadir/$database
            echo $new_ibddir
            #数据目录ibd文俊拷贝
            `cp -rp $old_ibdfile $new_ibddir`
            #加载ibd文件
            `mysql -u$username -h$host -P$port $database -A -Bse "ALTER TABLE $table IMPORT TABLESPACE";`
       done
        if [ $database = 'xcrm_wxsn_000' ]; then
        `mysql -u$username -h$host -P$port $database -A -Bse "source sequence.sql"`
    fi
done

#导出原实例的权限表
`mysqldump -h$old_host  -P$old_port -uold_username -p$old_userpwd -P$old_port mysql user db tables_priv columns_priv procs_priv --set-gtid-purged=OFF > /root/user.sql`
#导入新建实例
`mysql -u$username -h$host -P$port mysql < /root/user.sql`
