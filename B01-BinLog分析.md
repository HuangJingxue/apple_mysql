-找出写操作频繁的表
```sql
mysqlbinlog --no-defaults --base64-output=decode-rows -v -v mybinlog.000001 | awk '/###/{if($0~/UPDATE|INSERT|DELETE/)count[$2""$NF]++}END{for(i in count)print i,"\t",count[i]}'|column -t | sort -k3nr | more
INSERT`mysql`.`db`            2
INSERT`mysql`.`proxies_priv`  2
INSERT`mysql`.`user`          6
```
- 找出大事务
```sql
2020-09-10 

-rw-rw----. 1 mysql mysql 1.8G Jan 10 09:56 mybinlog.000819
-rw-rw----. 1 mysql mysql 1.2G Jan 10 10:04 mybinlog.000820

利用binlog2sql解析将binlog解析出详细sql

34># python /tmp/binlog2sql-master/binlog2sql/binlog2sql.py -h127.0.0.1 -P3306 -uroot -pxxx --start-file='mybinlog.000819' --start-datetime="2020-01-10 09:45:00" > binlog20200113.sql

34># python /tmp/binlog2sql-master/binlog2sql/binlog2sql.py -h127.0.0.1 -P3306 -uroot -pxxx --start-file='mybinlog.000820' --stop-datetime="2020-01-10 10:04:00" > binlog20200113_0.sql

cat binlog20200113.sql | awk -F '#start' '{print NR"#start"$2}' > binlog11.sql
cat binlog20200113_0.sql | awk -F '#start' '{print NR"#start"$2}' > binlog11_0.sql

文件处理
sed -i 's/#start/,/g;s/end/,/g;s/time/,/g' binlog11_0.sql > binlog11.txt
sed -i 's/#start/,/g;s/end/,/g;s/time/,/g' binlog11_0.sql > binlog11_0.txt


利用navicat 自建虚拟机中数据库
CREATE TABLE `a1` (
  `id` int(11) NOT NULL,
  `start` int(11) DEFAULT NULL,
  `end` int(11) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `a2` (
  `id` int(11) NOT NULL,
  `start` int(11) DEFAULT NULL,
  `end` int(11) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

利用导入向导将数据导入
[root@Oracle01 ~]# mysql -uroot -pxxx -e 'use qinxi;select start,count(start) cnt,min(end),max(end) from a1 group by start order by cnt desc;' > a1.sql

[root@Oracle01 ~]# mysql -uroot -pxxx -e 'use qinxi;select start,count(start) cnt,min(end),max(end) from a2 group by start order by cnt desc;' > a2.sql

--从而获取到大事务详情

```

- 找出热点表
```sql
利用mysqbinlog解析dml执行详情
mysqlbinlog --no-defaults --base64-output=decode-rows -v -v mybinlog.000820 --start-datetime="2020-01-09 09:45:00" | awk '/###/{if($0~/UPDATE|INSERT|DELETE/)count[$2""$NF]++}END{for(i in count)print i,"\t",count[i]}' | column -t | sort -k3nr | more > 'dml1.sql'

mysqlbinlog --no-defaults --base64-output=decode-rows -v -v mybinlog.000820 --stop-datetime="2020-01-10 10:04:00" | awk '/###/{if($0~/UPDATE|INSERT|DELETE/)count[$2""$NF]++}END{for(i in count)print i,"\t",count[i]}' | column -t | sort -k3nr | more > 'dml2.sql'

--从而获取到dml操作热点表
```

