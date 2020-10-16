#!/bin/bash
# kill掉 指定数据库kyh中超过1分钟的会话id，暴力，用于CPU持续飙高，临时解决问题
user=
password=
host=""
port=3306
 
# processlist snapshot
mysql -u$user -p$password -h$host  -P$port -e "select concat('kill ',id,';'),'KYHINFO',now(),id,user,host,db,command,time,state,info from information_schema.processlist where db='kk' and  time > 60"  > tmpfile
 
# save
cat tmpfile >> processlist_history.log
 
# kill
awk -F 'KYHINFO' '{if (NR != 1) print $1 }' tmpfile | mysql -u$user -p$password -h$host  -P$port
