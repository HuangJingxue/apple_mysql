mysql优化更改默认字符集老是出问题—如何正确更换字符集

字符集的简介：

​	mysql的字符集设置非常灵活，可以设置
​		1）服务器默认字符集
​		2）数据库默认字符集
​		3）表默认字符集 create table 表名（列声明）charset utf8;
​		4）列默认字符集
​		5）如果某一个级别没有指定字符集，则继承上一级
​		

	以表声明utf8为例：
		存储的数据在表中，最终是utf8
			
	字符集转换器工作原理：
		1）告诉服务器，我给你发的数据是什么编码的？ character_set_client
		2）告诉转换器，需要转换成什么编码？			character_set_connection
		3）告诉服务器，查询的结果用什么编码？		character_set_results
		
		如果三者都为utf8 ，则可以简写为 			set names utf8
		
	插入“中国”，并查询{
		/*查看当前字符集设置*/
		MariaDB [(none)]> show variables like 'character%';
		+--------------------------+----------------------------+
		| Variable_name            | Value                      |
		+--------------------------+----------------------------+
		| character_set_client     | utf8                       |/*客户端使用utf8*/
		| character_set_connection | utf8                       |/*转换器将客户端编码转为utf8*/
		| character_set_database   | latin1                     |/*数据库默认使用latin1*/
		| character_set_filesystem | binary                     |/*文件系统默认使用二进制*/
		| character_set_results    | utf8                       |/*服务器返回客户端的结果使用utf8*/
		| character_set_server     | latin1                     |
		| character_set_system     | utf8                       |
		| character_sets_dir       | /usr/share/mysql/charsets/ |
		+--------------------------+----------------------------+
		8 rows in set (0.08 sec)
		/**/
		/*服务器上创建表t10，使用utf8编码*/
		MariaDB [(none)]> create table test.t10 (name varchar(10)) charset utf8;
		Query OK, 0 rows affected (0.06 sec)
		/*客户端插入“中国utf8”--->转换器将“中国utf8”转为“中国utf8”--->服务器上使用utf8编码保存*/
		MariaDB [(none)]> insert into test.t10 values ('中国');
		Query OK, 1 row affected (0.03 sec)
		/*服务器返回查询结果使用utf8*/
		MariaDB [(none)]> select * from test.t10;
		+--------+
		| name   |
		+--------+
		| 中国   |
		+--------+
		1 row in set (0.00 sec)
		/*设置服务器返回查询结果使用gbk*/
		MariaDB [(none)]> set character_set_results=gbk;
		Query OK, 0 rows affected (0.00 sec)
		/*服务器返回查询结果使用gbk*/
		MariaDB [(none)]> select * from test.t10;
		+------+
		| name |
		+------+
		| א¹򞞠|
		+------+
		1 row in set (0.01 sec)



校对集

​	校对集就是排序规则
​		1）一种字符集可以有一个或多个排序规则
​		2）以UTF8为例，我们默认使用utf8_general_ci规则[a,B,c,D]，也可以按照二进制来排,utf8_bin[B,D,a,c]
​	

	如何声明校对集呢？
		create table () charset utf8 collation utf8_bin;


	排序例题{
	MariaDB [test]> create table test.t2 (id varchar(10)) charset utf8 collate utf8_bin;
	Query OK, 0 rows affected (0.04 sec)
	
	MariaDB [test]> insert into test.t2 values ('a'),('B'),('c'),('D');
	Query OK, 4 rows affected (0.03 sec)
	Records: 4  Duplicates: 0  Warnings: 0
	
	MariaDB [test]> select * from test.t2 order by id;
	+------+
	| id   |
	+------+
	| B    |
	| D    |
	| a    |
	| c    |
	+------+
	4 rows in set (0.04 sec)

1.为什么更改默认字符集（是否属于mysql优化）
满足应用支持语言的需求，应用处理各种各样的文字，发布到使用不同语言的国家或地区，可以选择Unicode字符集，MySQL的话可以选择UTF-8 

2.修改出错是否只有乱码一种情况，是否会存在其他的问题（给工作带来麻烦什么的）
如果应用中涉及已有数据的导入，就要充分考虑数据库字符集对已有数据的兼容性。
假设数据是GBK文字，如果选择其他数据库字符集，就可能导致某些文字无法正确导入的问题。 

3.如何正确更换字符集（除了Latin1字符还有其他常用的吗？）或者通性有哪些点

如果数据库需要支持一般是中文，数据量很大，性能要求也很高，可以选择双字节定长编码的中文字符集，比如GBK。 
因为相对于UTF-8而言，GBK比较小，每个汉字只占用2个字节，而UTF-8汉字编码需要3个字节，这样可以减少磁盘I/O，数据库缓存，已经网络传输的时间，从而提高性能。 
如果是英文字符，仅有少量汉字字符，那么选择UTF-8更好。 
如果数据库需要做大量的字符运算，如比较、排序，那么选择定长字符集可能会更好，因为定长字符集的处理速度比变长的快。

4.查看所有的字符集

```sql
mysql> show character set;
+----------+-----------------------------+---------------------+--------+
| Charset  | Description                 | Default collation   | Maxlen |
+----------+-----------------------------+---------------------+--------+
| big5     | Big5 Traditional Chinese    | big5_chinese_ci     |      2 |
| dec8     | DEC West European           | dec8_swedish_ci     |      1 |
| cp850    | DOS West European           | cp850_general_ci    |      1 |
| hp8      | HP West European            | hp8_english_ci      |      1 |
| koi8r    | KOI8-R Relcom Russian       | koi8r_general_ci    |      1 |
| latin1   | cp1252 West European        | latin1_swedish_ci   |      1 |
| latin2   | ISO 8859-2 Central European | latin2_general_ci   |      1 |
| swe7     | 7bit Swedish                | swe7_swedish_ci     |      1 |
| ascii    | US ASCII                    | ascii_general_ci    |      1 |
| ujis     | EUC-JP Japanese             | ujis_japanese_ci    |      3 |
| sjis     | Shift-JIS Japanese          | sjis_japanese_ci    |      2 |
| hebrew   | ISO 8859-8 Hebrew           | hebrew_general_ci   |      1 |
| tis620   | TIS620 Thai                 | tis620_thai_ci      |      1 |
| euckr    | EUC-KR Korean               | euckr_korean_ci     |      2 |
| koi8u    | KOI8-U Ukrainian            | koi8u_general_ci    |      1 |
| gb2312   | GB2312 Simplified Chinese   | gb2312_chinese_ci   |      2 |
| greek    | ISO 8859-7 Greek            | greek_general_ci    |      1 |
| cp1250   | Windows Central European    | cp1250_general_ci   |      1 |
| gbk      | GBK Simplified Chinese      | gbk_chinese_ci      |      2 |
| latin5   | ISO 8859-9 Turkish          | latin5_turkish_ci   |      1 |
| armscii8 | ARMSCII-8 Armenian          | armscii8_general_ci |      1 |
| utf8     | UTF-8 Unicode               | utf8_general_ci     |      3 |
| ucs2     | UCS-2 Unicode               | ucs2_general_ci     |      2 |
| cp866    | DOS Russian                 | cp866_general_ci    |      1 |
| keybcs2  | DOS Kamenicky Czech-Slovak  | keybcs2_general_ci  |      1 |
| macce    | Mac Central European        | macce_general_ci    |      1 |
| macroman | Mac West European           | macroman_general_ci |      1 |
| cp852    | DOS Central European        | cp852_general_ci    |      1 |
| latin7   | ISO 8859-13 Baltic          | latin7_general_ci   |      1 |
| utf8mb4  | UTF-8 Unicode               | utf8mb4_general_ci  |      4 |
| cp1251   | Windows Cyrillic            | cp1251_general_ci   |      1 |
| utf16    | UTF-16 Unicode              | utf16_general_ci    |      4 |
| cp1256   | Windows Arabic              | cp1256_general_ci   |      1 |
| cp1257   | Windows Baltic              | cp1257_general_ci   |      1 |
| utf32    | UTF-32 Unicode              | utf32_general_ci    |      4 |
| binary   | Binary pseudo charset       | binary              |      1 |
| geostd8  | GEOSTD8 Georgian            | geostd8_general_ci  |      1 |
| cp932    | SJIS for Windows Japanese   | cp932_japanese_ci   |      2 |
| eucjpms  | UJIS for Windows Japanese   | eucjpms_japanese_ci |      3 |
+----------+-----------------------------+---------------------+--------+
39 rows in set (0.00 sec)
```


可以参考的文档：https://blog.51cto.com/beckoning/2135505?source=dra

