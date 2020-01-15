概念
```wiki
last_slave  同步最靠前的节点
target slave
dead slave
```

缺点
```wiki
可行性原则优先场景无法使用MHA

主库数据补偿逻辑：GTID模型下，如果new_master和laster_slave_servers[0]不相等，先把new_master做成last_slave_server[0]的从，
然后从binlog_server上补偿日志（病态）；对非GTID环境，先利用last_slave_servers[0]de relay_log进行补偿，然后在利用主库保存的日志补偿。
```
数据补偿详情
```wiki
#非GTID环境：
主挂了，s2 为优先选举，先把s1的relay log获取出来将比s2多出的记录补上，根据s1上面的read_master_file和read_master_pos获取主库多出的记录补到s2数据
再将日志补到s2上面。s1 如果配置了purge relay log 就会有丢数据。

#GTID

不从old_master进行数据补偿。
```
切换过程
```wiki
第一步：do_master_failover,开始故障切换
第二步：force_shutdown,vip干掉
第三步：master数据补偿
       1、判断last_slave_server
       2、不是GTID保存master binlog
 ```      
 恢复过程
 ```wiki
 #GTID：
 new_master 会等待relaylog全部应用完。
 IO延迟，肯定会有数据丢失。
 
 #非GTID：
 
 优化建议
 ```wiki
 共享存储binlog。
 老的办法：每台机器划100-200G 库挂，master关掉，存储mount上，补偿数据。
 新的办法：5.7以后版本增强半同步，ceph共享存储
 架构方案：MGR
 
 keepalived 会有脑裂，云环境用不了
 ```
 参考：
 https://tech.meituan.com/2017/06/29/database-availability-architecture.html
 
       
