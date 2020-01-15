B02-MySQL字符集和排序规则

```sql
mysql> create database apple;
Query OK, 1 row affected (0.01 sec)


mysql> show create database apple;
+----------+---------------------------------------------------------------------------------------------------------------------------------+
| Database | Create Database                                                                                                                 |
+----------+---------------------------------------------------------------------------------------------------------------------------------+
| apple    | CREATE DATABASE `apple` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */ |
+----------+---------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)



mysql> create table jemp ( c JSON, g INT GENERATED ALWAYS AS (c->"$.id"), INDEX i (g) );
Query OK, 0 rows affected (0.03 sec)

mysql> insert into jemp(c) values ('{"id": "1","name": "Fred"}'),('{"id": "2","name": "wilma"}'),('{"id": "3","name": "Barney"}'),('{"id": "4","name": "Betty"}');
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> select c->>"$.name" as name from jemp where g > 2;
+--------+
| name   |
+--------+
| Barney |
| Betty  |
+--------+
2 rows in set (0.00 sec)

mysql> select c->>"$.id" as name from jemp where g > 2;
+------+
| name |
+------+
| 3    |
| 4    |
+------+
2 rows in set (0.00 sec)

```

