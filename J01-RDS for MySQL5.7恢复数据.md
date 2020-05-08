-下载逻辑备份
-解压备份
```bash
tar -xvf filename 
gzip -d filename
```
-备份处理
 ```bash
grep DEFINER _member_datafull_202005072343_1588866221_1.sql
awk '{ if (index($0,"GTID_PURGED")) { getline; while (length($0) > 0) { getline; } } else { print $0 } }' _member_datafull_202005072343_1588866221_1.sql | grep -iv 'set @@' > your_revised.sql
egrep -in "definer|set @@" your_revised.sql
```

-新库
newdb

- 导入命令
```bash
mysql -hurl -uxxx -pxxx zhebei_prod_member_2 < your_revised.sql
```
