--找出写操作频繁的表
```sql
mysqlbinlog --no-defaults --base64-output=decode-rows -v -v mybinlog.000001 | awk '/###/{if($0~/UPDATE|INSERT|DELETE/)count[$2""$NF]++}END{for(i in count)print i,"\t",count[i]}'|column -t | sort -k3nr | more
INSERT`mysql`.`db`            2
INSERT`mysql`.`proxies_priv`  2
INSERT`mysql`.`user`          6
```


