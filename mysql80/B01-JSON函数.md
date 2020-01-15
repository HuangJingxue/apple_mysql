# B01-JSON函数

> JSON函数：<https://dev.mysql.com/doc/refman/8.0/en/json-functions.html>
>
> JSON数据类型：<https://dev.mysql.com/doc/refman/8.0/en/json.html>
>
> 一组用于操作GeoJSON值的空间函数：<https://dev.mysql.com/doc/refman/8.0/en/spatial-geojson-functions.html>



## JSON 函数列表

|            | Name                                                         | Description                                                  |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 创建JSON值 | [JSON_ARRAY](https://dev.mysql.com/doc/refman/8.0/en/json-creation-functions.html#function_json-array) | Create JSON array                                            |
|            | [JSON_ARRAY_APPEND](<https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-array-append>) | Append data to JSON document                                 |
|            | [JSON_ARRAY_INSERT](<https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-array-insert>) | Insert into JSON array                                       |
|            | [->](<https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#operator_json-column-path>) | Return value from JSON column after evaluating path; equivalent to JSON_EXTRACT(). |
|            | [JSON_CONTAINS](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-contains) | Whether JSON document contains specific object at path       |
|            | [JSON_CONTAINS_PATH](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-contains-path) | Whether JSON document contains any data at path              |
|            | [JSON_DEPTH](https://dev.mysql.com/doc/refman/8.0/en/json-attribute-functions.html#function_json-depth) | Maximum depth of JSON document                               |
|            | [JSON_EXTRACT](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-extract) | Return data from JSON document                               |
|            | [->>](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#operator_json-inline-path) | Return value from JSON column after evaluating path and unquoting the result; equivalent to JSON_UNQUOTE(JSON_EXTRACT()). |
|            | [JSON_INSERT](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-insert) | Insert data into JSON document                               |
|            | [JSON_KEYS](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-keys) | Array of keys from JSON document                             |
|            | [JSON_LENGTH](https://dev.mysql.com/doc/refman/8.0/en/json-attribute-functions.html#function_json-length) | Number of elements in JSON document                          |
|            | [JSON_MERGE](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-merge) (deprecated 8.0.3) | Merge JSON documents, preserving duplicate keys. Deprecated synonym for JSON_MERGE_PRESERVE() |
|            | [JSON_MERGE_PATCH](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-merge-patch) | Merge JSON documents, replacing values of duplicate keys     |
|            | [JSON_MERGE_PRESERVE](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-merge-preserve) | Merge JSON documents, preserving duplicate keys              |
| 创建JSON值 | [JSON_OBJECT](https://dev.mysql.com/doc/refman/8.0/en/json-creation-functions.html#function_json-object) | Create JSON object                                           |
|            | [JSON_OVERLAPS](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-overlaps) | Compares two JSON documents, returns TRUE (1) if these have any key-value pairs or array elements in common, otherwise FALSE (0) |
|            | [JSON_PRETTY](https://dev.mysql.com/doc/refman/8.0/en/json-utility-functions.html#function_json-pretty) | Print a JSON document in human-readable format               |
| 创建JSON值 | [JSON_QUOTE](https://dev.mysql.com/doc/refman/8.0/en/json-creation-functions.html#function_json-quote) | Quote JSON document                                          |
|            | [JSON_REMOVE](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-remove) | Remove data from JSON document                               |
|            | [JSON_REPLACE](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-replace) | Replace values in JSON document                              |
|            | [JSON_SCHEMA_VALID](https://dev.mysql.com/doc/refman/8.0/en/json-validation-functions.html#function_json-schema-valid) | Validate JSON document against JSON schema; returns TRUE/1 if document validates against schema, or FALSE/0 if it does not |
|            | [JSON_SCHEMA_VALIDATION_REPORT](https://dev.mysql.com/doc/refman/8.0/en/json-validation-functions.html#function_json-schema-validation-report) | Validate JSON document against JSON schema; returns report in JSON format on outcome on validation including success or failure and reasons for failure |
|            | [JSON_SEARCH](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-search) | Path to value within JSON document                           |
|            | [JSON_SET](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-set) | Insert data into JSON document                               |
|            | [JSON_STORAGE_FREE](https://dev.mysql.com/doc/refman/8.0/en/json-utility-functions.html#function_json-storage-free) | Freed space within binary representation of JSON column value following partial update |
|            | [JSON_STORAGE_SIZE](https://dev.mysql.com/doc/refman/8.0/en/json-utility-functions.html#function_json-storage-size) | Space used for storage of binary representation of a JSON document |
|            | [JSON_TABLE](https://dev.mysql.com/doc/refman/8.0/en/json-table-functions.html#function_json-table) | Return data from a JSON expression as a relational table     |
|            | [JSON_TYPE](https://dev.mysql.com/doc/refman/8.0/en/json-attribute-functions.html#function_json-type) | Type of JSON value                                           |
|            | [JSON_UNQUOTE](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-unquote) | Unquote JSON value                                           |
|            | [JSON_VALID](https://dev.mysql.com/doc/refman/8.0/en/json-attribute-functions.html#function_json-valid) | Whether JSON value is valid                                  |
|            | [MEMBER OF](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#operator_member-of) | Returns true (1) if first operand matches any element of JSON array passed as second operand, otherwise returns false (0) |
|            | [JSON_ARRAYAGG](https://dev.mysql.com/doc/refman/8.0/en/group-by-functions.html#function_json-arrayagg) | Return result set as a single JSON array                     |
|            | [JSON_OBJECTAGG](https://dev.mysql.com/doc/refman/8.0/en/group-by-functions.html#function_json-objectagg) | Return result set as a single JSON object                    |

### 创建JSON值的函数

- JSON_ARRAY  计算（可能为空）值列表并返回包含这些值的JSON数组。

  ```sql
  mysql> select json_array(1,'apple',18,NULL,'leo',CURTIME());
  +--------------------------------------------------+
  | json_array(1,'apple',18,null,'leo',CURTIME())    |
  +--------------------------------------------------+
  | [1, "apple", 18, null, "leo", "11:43:10.000000"] |
  +--------------------------------------------------+
  1 row in set (0.00 sec)
  
  ```

- JSON_OBJECT  计算键值对（可能为空）并返回包含这些对的JSON对象。如果任何键名称`NULL`或参数数量为奇数，则会发生错误。

```sql
mysql> select json_object('id',1,'name','apple','date',CURTIME());
+-------------------------------------------------------+
| json_object('id',1,'name','apple','date',CURTIME())   |
+-------------------------------------------------------+
| {"id": 1, "date": "11:49:04.000000", "name": "apple"} |
+-------------------------------------------------------+
1 row in set (0.00 sec)

mysql> select json_object('id',1,'name','apple','date');
ERROR 1582 (42000): Incorrect parameter count in the call to native function 'json_object'

mysql> select json_object(NULL,NULL);
ERROR 3158 (22032): JSON documents may not contain NULL member names.

```

- JSON_QUOTE  通过用双引号字符包装并转义内部引号和其他字符，然后将结果作为`utf8mb4`字符串返回，将字符串引用为JSON值 。`NULL`如果参数是，则 返回 `NULL`。此函数通常用于生成有效的JSON字符串文字以包含在JSON文档中。

```sql
mysql> select json_quote('null'),json_quote('"null"');
+--------------------+----------------------+
| json_quote('null') | json_quote('"null"') |
+--------------------+----------------------+
| "null"             | "\"null\""           |
+--------------------+----------------------+
1 row in set (0.00 sec)

mysql> select json_quote('[1,2,3]');
+-----------------------+
| json_quote('[1,2,3]') |
+-----------------------+
| "[1,2,3]"             |
+-----------------------+
1 row in set (0.00 sec)

```

### 搜索JSON值的函数

- JSON_CONTAINS 通过返回1或0来指示给定的 *candidate*JSON文档是否包含在*target*JSON文档中，或者 - 如果提供了*path* 参数 - 是否在目标内的特定路径中找到候选项。返回 `NULL`如果任何参数 `NULL`，或者如果路径参数不识别目标文档的一部分。如果发生错误 *target*或 *candidate*不是有效的JSON文档，或者如果*path*参数不是一个有效的路径表达式或包含一个`*`或`**`通配符。

```sql
mysql> set @j='{"a": 1,"b": 2,"c": {"d": 4}}';
mysql> set @j2 = '1';

mysql> select json_contains(@j,@j2,'$.a');
+-----------------------------+
| json_contains(@j,@j2,'$.a') |
+-----------------------------+
|                           1 |
+-----------------------------+
1 row in set (0.00 sec)

mysql> select json_contains(@j,@j2,'$.c');
+-----------------------------+
| json_contains(@j,@j2,'$.c') |
+-----------------------------+
|                           0 |
+-----------------------------+
1 row in set (0.00 sec)

mysql> set @j2 = '{"d": 4}';
Query OK, 0 rows affected (0.00 sec)

mysql> select json_contains(@j,@j2,'$.c');
+-----------------------------+
| json_contains(@j,@j2,'$.c') |
+-----------------------------+
|                           1 |
+-----------------------------+
1 row in set (0.00 sec)

mysql> select json_contains(@j,@j2,'$.a');
+-----------------------------+
| json_contains(@j,@j2,'$.a') |
+-----------------------------+
|                           0 |
+-----------------------------+
1 row in set (0.00 sec)

```

- JSON_CONTAINS_PATH

  `'one'`：如果文档中至少存在一个路径，则为1，否则为0。

  `'all'`：如果文档中存在所有路径，则为1，否则为0。

 ```sql
  mysql> set @j = '{"a": 1,"b": 2,"c": {"d": 4}}';
  Query OK, 0 rows affected (0.00 sec)
  
  mysql> select json_contains_path(@j,'one','$.a','$.e');
  +------------------------------------------+
  | json_contains_path(@j,'one','$.a','$.e') |
  +------------------------------------------+
  |                                        1 |
  +------------------------------------------+
  1 row in set (0.00 sec)
  
  mysql> select json_contains_path(@j,'all','$.a','$.e');
  +------------------------------------------+
  | json_contains_path(@j,'all','$.a','$.e') |
  +------------------------------------------+
  |                                        0 |
  +------------------------------------------+
  1 row in set (0.00 sec)
  
  mysql> select json_contains_path(@j,'all','$.a','$.c');
  +------------------------------------------+
  | json_contains_path(@j,'all','$.a','$.c') |
  +------------------------------------------+
  |                                        1 |
  +------------------------------------------+
  1 row in set (0.00 sec)
  
  mysql> select json_contains_path(@j,'one','$.c.d');
  +--------------------------------------+
  | json_contains_path(@j,'one','$.c.d') |
  +--------------------------------------+
  |                                    1 |
  +--------------------------------------+
  1 row in set (0.00 sec)
  
  mysql> select json_contains_path(@j,'one','$.a.d');
  +--------------------------------------+
  | json_contains_path(@j,'one','$.a.d') |
  +--------------------------------------+
  |                                    0 |
  +--------------------------------------+
  1 row in set (0.00 sec)
  
 ```

- JSON_EXTRACT 返回JSON文档中的数据，该文档从*path* 参数匹配的文档部分中选择。返回`NULL`如果任何参数 `NULL`或没有路径找到文档中的一个值。如果*json_doc*参数不是有效的JSON文档或任何*path*参数不是有效的路径表达式，则会发生错误 。

```sql
mysql> select json_extract('[10,20,[30,40]]','$[1]');
+----------------------------------------+
| json_extract('[10,20,[30,40]]','$[1]') |
+----------------------------------------+
| 20                                     |
+----------------------------------------+
1 row in set (0.00 sec)

mysql> select json_extract('[10,20,[30,40]]','$[0]');
+----------------------------------------+
| json_extract('[10,20,[30,40]]','$[0]') |
+----------------------------------------+
| 10                                     |
+----------------------------------------+
1 row in set (0.00 sec)

mysql> select json_extract('[10,20,[30,40]]','$[1]','$[0]');
+-----------------------------------------------+
| json_extract('[10,20,[30,40]]','$[1]','$[0]') |
+-----------------------------------------------+
| [20, 10]                                      |
+-----------------------------------------------+
1 row in set (0.00 sec)

mysql> select json_extract('[10,20,[30,40]]','$[2][1]');
+-------------------------------------------+
| json_extract('[10,20,[30,40]]','$[2][1]') |
+-------------------------------------------+
| 40                                        |
+-------------------------------------------+
1 row in set (0.00 sec)

mysql> select json_extract('[10,20,[30,40]]','$[2][*]');
+-------------------------------------------+
| json_extract('[10,20,[30,40]]','$[2][*]') |
+-------------------------------------------+
| [30, 40]                                  |
+-------------------------------------------+
1 row in set (0.00 sec)

```

- -> 当与两个参数一起使用时 ， [`->`](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#operator_json-column-path) 运算符充当[`JSON_EXTRACT()`](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-extract)函数的别名， 左侧是列标识符，右侧是根据JSON文档评估的JSON路径（列值）。您可以使用此类表达式代替SQL语句中出现的列标识符。

```sql
mysql> select c,json_extract(c,"$.id"),g from jemp where json_extract(c,"$.id") >1 order by json_extract(c,"$.name");
+-------------------------------+------------------------+------+
| c                             | json_extract(c,"$.id") | g    |
+-------------------------------+------------------------+------+
| {"id": "3", "name": "Barney"} | "3"                    |    3 |
| {"id": "4", "name": "Betty"}  | "4"                    |    4 |
| {"id": "2", "name": "wilma"}  | "2"                    |    2 |
+-------------------------------+------------------------+------+
3 rows in set (0.00 sec)

mysql> select c,c->"$.id" ,g from jemp where c->"$.id" > 1 order by c->"$.name";
+-------------------------------+-----------+------+
| c                             | c->"$.id" | g    |
+-------------------------------+-----------+------+
| {"id": "3", "name": "Barney"} | "3"       |    3 |
| {"id": "4", "name": "Betty"}  | "4"       |    4 |
| {"id": "2", "name": "wilma"}  | "2"       |    2 |
+-------------------------------+-----------+------+
3 rows in set (0.00 sec)

```

> 此功能不限与select

- ->> 

[`JSON_UNQUOTE(`](https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html#function_json-unquote) [`JSON_EXTRACT(*column*, *path*) )`](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-extract)

`JSON_UNQUOTE(*column*` [`->`](https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#operator_json-column-path) `*path*)`

`*column*->>*path*`

```sql
mysql> select c->'$.name' from jemp where g > 2;
+-------------+
| c->'$.name' |
+-------------+
| "Barney"    |
| "Betty"     |
+-------------+
2 rows in set (0.00 sec)

mysql> select c->>'$.name' from jemp where g > 2;
+--------------+
| c->>'$.name' |
+--------------+
| Barney       |
| Betty        |
+--------------+
2 rows in set (0.00 sec)

mysql> select json_unquote(c->'$.name') from jemp where g > 2;
+---------------------------+
| json_unquote(c->'$.name') |
+---------------------------+
| Barney                    |
| Betty                     |
+---------------------------+
2 rows in set (0.00 sec)

```

> 此运算符也可以与JSON数组一起使用

- JSON_KEYS  从JSON对象的顶级值返回键作为JSON数组，或者，如果*path* 给出参数，则返回所选路径中的顶级键。`NULL`如果有任何参数`NULL`，则返回参数 ，该 *json_doc*参数不是对象，或者*path*，如果给定，则不返回对象。如果*json_doc*参数不是有效的JSON文档或*path*参数不是有效的路径表达式或包含 `*`或`**`通配符，则会发生错误 。

```sql
mysql> select json_keys('{"a": 1,"b": {"c": 30}}');
+--------------------------------------+
| json_keys('{"a": 1,"b": {"c": 30}}') |
+--------------------------------------+
| ["a", "b"]                           |
+--------------------------------------+
1 row in set (0.00 sec)

mysql> select json_keys('{"a": 1,"b": {"c": 30}}','$.b');
+--------------------------------------------+
| json_keys('{"a": 1,"b": {"c": 30}}','$.b') |
+--------------------------------------------+
| ["c"]                                      |
+--------------------------------------------+
1 row in set (0.01 sec)

mysql> select json_keys('{"a": 1,"b": {"c": 30}}','$.c');
+--------------------------------------------+
| json_keys('{"a": 1,"b": {"c": 30}}','$.c') |
+--------------------------------------------+
| NULL                                       |
+--------------------------------------------+
1 row in set (0.00 sec)

mysql> select json_keys('{"a": 1,"b": {"c": 30}}','$.a');
+--------------------------------------------+
| json_keys('{"a": 1,"b": {"c": 30}}','$.a') |
+--------------------------------------------+
| NULL                                       |
+--------------------------------------------+
1 row in set (0.00 sec)

```

- JSON_OVERLAPS 比较两个JSON文档。如果两个文档具有任何共同的键值对或数组元素，则返回true（1）。如果两个参数都是标量，则该函数执行简单的相等性测试。

```sql
mysql> SELECT JSON_OVERLAPS("[1,3,5,7]", "[2,6,7]");
+---------------------------------------+
| JSON_OVERLAPS("[1,3,5,7]", "[2,6,7]") |
+---------------------------------------+
|                                     1 |
+---------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_OVERLAPS("[1,3,5,7]", "[2,6,8]");
+---------------------------------------+
| JSON_OVERLAPS("[1,3,5,7]", "[2,6,8]") |
+---------------------------------------+
|                                     0 |
+---------------------------------------+
1 row in set (0.00 sec)

```

>  `JSON_OVERLAPS()` 在MySQL 8.0.17中添加了。该函数不执行类型转换
>
> ERROR 1305 (42000): FUNCTION apple.json_overlaps does not exist 

- JSON_SEARCH 返回JSON文档中给定字符串的路径

`'one'`：搜索在第一个匹配后终止，并返回一个路径字符串。未定义哪个匹配首先考虑。

`'all'`：搜索返回所有匹配的路径字符串，以便不包含重复的路径。如果有多个字符串，则将它们自动包装为数组。数组元素的顺序未定义。

```sql
mysql> SET @j = '["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]';
Query OK, 0 rows affected (0.00 sec)

mysql> select json_search(@j,'one','abc');
+-----------------------------+
| json_search(@j,'one','abc') |
+-----------------------------+
| "$[0]"                      |
+-----------------------------+
1 row in set (0.00 sec)

mysql> select json_search(@j,'all','abc');
+-----------------------------+
| json_search(@j,'all','abc') |
+-----------------------------+
| ["$[0]", "$[2].x"]          |
+-----------------------------+
1 row in set (0.00 sec)

mysql> select json_search(@j,'all',10);
+--------------------------+
| json_search(@j,'all',10) |
+--------------------------+
| "$[1][0].k"              |
+--------------------------+
1 row in set (0.00 sec)

```

- MEMBER OF(json_array) *value*是元素*json_array*，则返回true（1），否则返回false（0）,该`MEMBER OF()`操作符已添加到MySQL 8.0.17中。

```sql

mysql> SET @a = CAST('{"a": 1}' AS JSON);
Query OK, 0 rows affected (0.00 sec)

mysql> SET @b = JSON_OBJECT("b", 2);
Query OK, 0 rows affected (0.00 sec)

mysql> set @c = JSON_ARRAY(17,@b,"abc",@a,23);
Query OK, 0 rows affected (0.00 sec)

mysql> select @c;
+---------------------------------------------+
| @c                                          |
+---------------------------------------------+
| [17, "{\"b\": 2}", "abc", "{\"a\": 1}", 23] |
+---------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT @a MEMBER OF(@c), @b MEMBER OF(@c);
+------------------+------------------+
| @a MEMBER OF(@c) | @b MEMBER OF(@c) |
+------------------+------------------+
|                1 |                1 |
+------------------+------------------+
1 row in set (0.00 sec)
```

### 修改JSON值的函数

- JSON_ARRAY_APPEND  将值附加到JSON文档中指定数组的末尾并返回结果。在MySQL 5.7中，这个函数被命名了 `JSON_APPEND()`。MySQL 8.0不再支持该名称。

```sql
mysql> set @j = '["a",["b","c"],"d"]';
Query OK, 0 rows affected (0.00 sec)

mysql> select json_array_append(@j,'$[1]', 1)
    -> ;
+---------------------------------+
| json_array_append(@j,'$[1]', 1) |
+---------------------------------+
| ["a", ["b", "c", 1], "d"]       |
+---------------------------------+
1 row in set (0.00 sec)

mysql> 

```

- JSON_ARRAY_INSERT  更新JSON文档，插入文档中的数组并返回修改后的文档。路径未标识JSON文档中的任何数组的对将被忽略。较早的修改会影响数组中以下元素的位置。

```sql
mysql> select json_array_insert(@j,'$[100]','x');
+------------------------------------+
| json_array_insert(@j,'$[100]','x') |
+------------------------------------+
| ["a", ["b", "c"], "d", "x"]        |
+------------------------------------+
1 row in set (0.00 sec)

mysql> select json_array_insert(json_array_append(@j,'$', "[3,4]"),'$[3]','y');
+------------------------------------------------------------------+
| json_array_insert(json_array_append(@j,'$', "[3,4]"),'$[3]','y') |
+------------------------------------------------------------------+
| ["a", ["b", "c"], "d", "y", "[3,4]"]                             |
+------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SET @j = '["a", {"b": [1, 2]}, [3, 4]]';
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT JSON_ARRAY_INSERT(@j, '$[1].b[0]', 'x');
+-----------------------------------------+
| JSON_ARRAY_INSERT(@j, '$[1].b[0]', 'x') |
+-----------------------------------------+
| ["a", {"b": ["x", 1, 2]}, [3, 4]]       |
+-----------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_ARRAY_INSERT(@j, '$[0]', 'x', '$[1].b[0]', 'y');
+------------------------------------------------------+
| JSON_ARRAY_INSERT(@j, '$[0]', 'x', '$[1].b[0]', 'y') |
+------------------------------------------------------+
| ["x", "a", {"b": [1, 2]}, [3, 4]]                    |
+------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_ARRAY_INSERT(@j, '$[0]', 'x', '$[2].b[0]', 'y');
+------------------------------------------------------+
| JSON_ARRAY_INSERT(@j, '$[0]', 'x', '$[2].b[0]', 'y') |
+------------------------------------------------------+
| ["x", "a", {"b": ["y", 1, 2]}, [3, 4]]               |
+------------------------------------------------------+
1 row in set (0.00 sec)


```

- JSON_INSERT  将数据插入JSON文档并返回结果。`NULL`如果有任何参数，则 返回`NULL`。如果发生错误 *json_doc*的参数是不是一个有效的JSON文档或任何*path*参数是不是有效的路径表达式或包含一个 `*`或`**`通配符。

```sql
mysql> mysql> set{"a": 1, "b": [2,3]}';
Query OK, 0 rows affected (0.00 sec)

mysql> select json_insert(@j, '$.a', 10, '$.c', '[true, false]');
+----------------------------------------------------+
| json_insert(@j, '$.a', 10, '$.c', '[true, false]') |
+----------------------------------------------------+
| {"a": 1, "b": [2, 3], "c": "[true, false]"}        |
+----------------------------------------------------+
1 row in set (0.00 sec)

mysql> select json_insert(@j, '$.a', 10, '$.c', CAST('[true, false]' as json));
+------------------------------------------------------------------+
| json_insert(@j, '$.a', 10, '$.c', CAST('[true, false]' as json)) |
+------------------------------------------------------------------+
| {"a": 1, "b": [2, 3], "c": [true, false]}                        |
+------------------------------------------------------------------+
1 row in set (0.00 sec)

```

- JSON_MERGE

```sql
mysql> SELECT JSON_MERGE('[1, 2]', '[true, false]');
+---------------------------------------+
| JSON_MERGE('[1, 2]', '[true, false]') |
+---------------------------------------+
| [1, 2, true, false]                   |
+---------------------------------------+
1 row in set, 1 warning (0.00 sec)

```

- JSON_MERGE_PATCH() `JSON_MERGE_PATCH()` MySQL 8.0.3及更高版本支持。

1. 如果第一个参数不是对象，则合并的结果是第二个参数。
2. 如果第二个参数不是对象，则合并的结果是第二个参数。
3. 如果两个参数都是对象，则合并的结果是具有以下成员的对象：
   - 第一个对象的所有成员没有在第二个对象中具有相同键的相应成员。
   - 第二个对象的所有成员在第一个对象中没有对应的键，其值不是JSON `null`文字。
   - 具有在第一个和第二个对象中存在的键的所有成员，返回第二个对象中的值。这些成员的值是以递归方式将第一个对象中的值与第二个对象中的值合并的结果。

```sql
mysql> SELECT JSON_MERGE_PATCH('[1, 2]', '[true, false]');
+---------------------------------------------+
| JSON_MERGE_PATCH('[1, 2]', '[true, false]') |
+---------------------------------------------+
| [true, false]                               |
+---------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}');
+-------------------------------------------------+
| JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}') |
+-------------------------------------------------+
| {"id": 47, "name": "x"}                         |
+-------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_MERGE_PATCH('{ "a": 1, "b":2 }','{"c": 1, "d": 2}');
+----------------------------------------------------------+
| JSON_MERGE_PATCH('{ "a": 1, "b":2 }','{"c": 1, "d": 2}') |
+----------------------------------------------------------+
| {"a": 1, "b": 2, "c": 1, "d": 2}                         |
+----------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_MERGE_PATCH('{ "a": 1, "b":2 }','{ "a": 3, "c":4 }','{ "a": 5, "d":6 }');
+-------------------------------------------------------------------------------+
| JSON_MERGE_PATCH('{ "a": 1, "b":2 }','{ "a": 3, "c":4 }','{ "a": 5, "d":6 }') |
+-------------------------------------------------------------------------------+
| {"a": 5, "b": 2, "c": 4, "d": 6}                                              |
+-------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"b":null}');
+--------------------------------------------------+
| JSON_MERGE_PATCH('{"a":1, "b":2}', '{"b":null}') |
+--------------------------------------------------+
| {"a": 1}                                         |
+--------------------------------------------------+
1 row in set (0.00 sec)
-- 表明该函数以递归方式运行,存在疑问
```

**JSON_MERGE_PATCH（）与JSON_MERGE_PRESERVE（）进行比较。**

```sql
mysql> set @x = '{ "a": 1, "b":2 }',@y = '{ "a": 3, "c": 4}',@z = '{"a": 5, "d": 6}';
Query OK, 0 rows affected (0.00 sec)

mysql> select json_merge_patch(@x, @y, @z) as patch,json_merge_preserve(@x, @y, @z) as preserve\G;
*************************** 1. row ***************************
   patch: {"a": 5, "b": 2, "c": 4, "d": 6}
preserve: {"a": [1, 3, 5], "b": 2, "c": 4, "d": 6}
1 row in set (0.00 sec)

```

- JSON_REMOVE 从JSON文档中删除数据并返回结果。

```sql
mysql> SET @j = '["a", ["b", "c"], "d"]';
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT JSON_REMOVE(@j, '$[1]');
+-------------------------+
| JSON_REMOVE(@j, '$[1]') |
+-------------------------+
| ["a", "d"]              |
+-------------------------+
1 row in set (0.00 sec)

```

- JSON_REPLACE  替换JSON文档中的现有值并返回结果。

```shell
mysql> SET @j = '{ "a": 1, "b": [2, 3]}';
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT JSON_REPLACE(@j, '$.a', 10, '$.c', '[true, false]');
+-----------------------------------------------------+
| JSON_REPLACE(@j, '$.a', 10, '$.c', '[true, false]') |
+-----------------------------------------------------+
| {"a": 10, "b": [2, 3]}                              |
+-----------------------------------------------------+
1 row in set (0.00 sec)

```

- JSON_SET

```shell
mysql> SELECT JSON_SET(@j, '$.a', 10, '$.c', '[true, false]');
+-------------------------------------------------+
| JSON_SET(@j, '$.a', 10, '$.c', '[true, false]') |
+-------------------------------------------------+
| {"a": 10, "b": [2, 3], "c": "[true, false]"}    |
+-------------------------------------------------+
1 row in set (0.00 sec)

```

>  json_set  替换现有值并添加不存在的值;json_insert  插入值而不替换现有值;json_replace  仅*替换 现有值

- JSON_UNQUOTE

| Escape Sequence | Character Represented by Sequence    |
| --------------- | ------------------------------------ |
| `\"`            | A double quote (`"`) character       |
| `\b`            | A backspace character                |
| `\f`            | A formfeed character                 |
| `\n`            | A newline (linefeed) character       |
| `\r`            | A carriage return character          |
| `\t`            | A tab character                      |
| `\\`            | A backslash (`\`) character          |
| `\u*XXXX*`      | UTF-8 bytes for Unicode value *XXXX* |

```sql
mysql> SET @j = '"abc"';
mysql> SELECT @j, JSON_UNQUOTE(@j);
+-------+------------------+
| @j    | JSON_UNQUOTE(@j) |
+-------+------------------+
| "abc" | abc              |
+-------+------------------+

mysql> SET @j = '[1, 2, 3]';
mysql> SELECT @j, JSON_UNQUOTE(@j);
+-----------+------------------+
| @j        | JSON_UNQUOTE(@j) |
+-----------+------------------+
| [1, 2, 3] | [1, 2, 3]        |
+-----------+------------------+

mysql> SELECT @@sql_mode;
+------------+
| @@sql_mode |
+------------+
|            |
+------------+

mysql> SELECT JSON_UNQUOTE('"\\t\\u0032"');
+------------------------------+
| JSON_UNQUOTE('"\\t\\u0032"') |
+------------------------------+
|       2                           |
+------------------------------+

mysql> SET @@sql_mode = 'NO_BACKSLASH_ESCAPES';
mysql> SELECT JSON_UNQUOTE('"\\t\\u0032"');
+------------------------------+
| JSON_UNQUOTE('"\\t\\u0032"') |
+------------------------------+
| \t\u0032                     |
+------------------------------+

mysql> SELECT JSON_UNQUOTE('"\t\u0032"');
+----------------------------+
| JSON_UNQUOTE('"\t\u0032"') |
+----------------------------+
|       2                         |
+----------------------------+
```

### 返回JSON值属性的函数

- JSON_DEPTH 返回JSON文档的最大深度。

```sql
mysql> select json_depth('{}'),json_depth('[]'),json_depth('true'),json_depth('[10,20]'),json_depth('[10,{"a": 20}]');
+------------------+------------------+--------------------+-----------------------+------------------------------+
| json_depth('{}') | json_depth('[]') | json_depth('true') | json_depth('[10,20]') | json_depth('[10,{"a": 20}]') |
+------------------+------------------+--------------------+-----------------------+------------------------------+
|                1 |                1 |                  1 |                     2 |                            3 |
+------------------+------------------+--------------------+-----------------------+------------------------------+
1 row in set (0.00 sec)

```

- JSON_LENGTH  返回JSON文档的长度。

  文件的长度确定如下：

  - 标量的长度为1。
  - 数组的长度是数组元素的数量。
  - 对象的长度是对象成员的数量。
  - 长度不计算嵌套数组或对象的长度。

```sql
mysql> select json_length('[1, 2, {"a": 3}]'),json_length('{"a": 1, "b": {"c": 30}}'),json_length('{"a": 1,"b": {"c": 30}}','$.b');
+---------------------------------+-----------------------------------------+----------------------------------------------+
| json_length('[1, 2, {"a": 3}]') | json_length('{"a": 1, "b": {"c": 30}}') | json_length('{"a": 1,"b": {"c": 30}}','$.b') |
+---------------------------------+-----------------------------------------+----------------------------------------------+
|                               3 |                                       2 |                                            1 |
+---------------------------------+-----------------------------------------+----------------------------------------------+
1 row in set (0.00 sec)

```

- JSON_TYPE 返回`utf8mb4`表示JSON值类型的字符串。如果参数不是有效的JSON值，则会发生错误：

```sql
mysql> set @j = '{"a": [10, true]}';
Query OK, 0 rows affected (0.00 sec)

mysql> select json_type(@j),json_type(json_extract(@j, '$.a')),json_type(json_extract(@j, '$.a[0]')),json_type(json_extract(@j, '$.a[1]')),json_type(NULL);
+---------------+------------------------------------+---------------------------------------+---------------------------------------+-----------------+
| json_type(@j) | json_type(json_extract(@j, '$.a')) | json_type(json_extract(@j, '$.a[0]')) | json_type(json_extract(@j, '$.a[1]')) | json_type(NULL) |
+---------------+------------------------------------+---------------------------------------+---------------------------------------+-----------------+
| OBJECT        | ARRAY                              | INTEGER                               | BOOLEAN                               | NULL            |
+---------------+------------------------------------+---------------------------------------+---------------------------------------+-----------------+
1 row in set (0.00 sec)

```

> - 纯 JSON 类型:
>   - `OBJECT`: JSON objects
>   - `ARRAY`: JSON arrays
>   - `BOOLEAN`: The JSON true and false literals
>   - `NULL`: The JSON null literal
> - 数值类型:
>   - `INTEGER`: MySQL [`TINYINT`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html), [`SMALLINT`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html), [`MEDIUMINT`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html) and [`INT`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html) and [`BIGINT`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html) scalars
>   - `DOUBLE`: MySQL [`DOUBLE`](https://dev.mysql.com/doc/refman/8.0/en/floating-point-types.html) [`FLOAT`](https://dev.mysql.com/doc/refman/8.0/en/floating-point-types.html) scalars
>   - `DECIMAL`: MySQL [`DECIMAL`](https://dev.mysql.com/doc/refman/8.0/en/fixed-point-types.html) and [`NUMERIC`](https://dev.mysql.com/doc/refman/8.0/en/fixed-point-types.html) scalars
> - 时间类型:
>   - `DATETIME`: MySQL [`DATETIME`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) and [`TIMESTAMP`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) scalars
>   - `DATE`: MySQL [`DATE`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) scalars
>   - `TIME`: MySQL [`TIME`](https://dev.mysql.com/doc/refman/8.0/en/time.html) scalars
> - 字符类型:
>   - `STRING`: MySQL `utf8` character type scalars: [`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html), [`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html), [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html), [`ENUM`](https://dev.mysql.com/doc/refman/8.0/en/enum.html), and [`SET`](https://dev.mysql.com/doc/refman/8.0/en/set.html)
> - 二进制类型:
>   - `BLOB`: MySQL binary type scalars including [`BINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html), [`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html), [`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html), and [`BIT`](https://dev.mysql.com/doc/refman/8.0/en/bit-type.html)
> - All other types:
>   - `OPAQUE` (raw bits)

- JSON_VALID 返回0或1以指示值是否为有效JSON

```shell
mysql> select json_valid('{"a": 1}'),json_valid('hello'),json_valid('"hello"');
+------------------------+---------------------+-----------------------+
| json_valid('{"a": 1}') | json_valid('hello') | json_valid('"hello"') |
+------------------------+---------------------+-----------------------+
|                      1 |                   0 |                     1 |
+------------------------+---------------------+-----------------------+
1 row in set (0.00 sec)

```

### JSON表函数

- JSON_TABLE  JSON数据转换为表格数据的JSON函数的信息，在MySQL 8.0.4及更高版本中，`JSON_TABLE()`支持一个这样的功能

```sql
mysql> select * from json_table('[{"a": 3},{"a": 2},{"b": 1},{"a": 0},{"a": [1,2]}]',"$[*]" columns(rowid for ordinality,ac varchar(100) path "$.a" default '999' on error default '111' on empty,aj json path "$.a" default '{"x": 333}' on empty,bx int exists path "$.b")) as tt;
+-------+------+------------+------+
| rowid | ac   | aj         | bx   |
+-------+------+------------+------+
|     1 | 3    | 3          |    0 |
|     2 | 2    | 2          |    0 |
|     3 | 111  | {"x": 333} |    1 |
|     4 | 0    | 0          |    0 |
|     5 | 999  | [1, 2]     |    0 |
+-------+------+------------+------+
5 rows in set (0.00 sec)

mysql> select * from json_table('[{"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}]','$[*]' COLUMNS(a INT PATH '$.a',NESTED PATH '$.b[*]' COLUMNS (b1 INT PATH '$'),NESTED PATH '$.b[*]' COLUMNS (b2 INT PATH '$'))) as jt;
+------+------+------+
| a    | b1   | b2   |
+------+------+------+
|    1 |   11 | NULL |
|    1 |  111 | NULL |
|    1 | NULL |   11 |
|    1 | NULL |  111 |
|    2 |   22 | NULL |
|    2 |  222 | NULL |
|    2 | NULL |   22 |
|    2 | NULL |  222 |
+------+------+------+
8 rows in set (0.00 sec)
-- 存在疑问没有理解

mysql> SELECT *
    ->  FROM
    ->    JSON_TABLE(
    ->      '[{"a": "a_val",
    '>        "b": [{"c": "c_val", "l": [1,2]}]},
    '>      {"a": "a_val",
    '>        "b": [{"c": "c_val","l": [11]}, {"c": "c_val", "l": [22]}]}]',
    ->      '$[*]' COLUMNS(
    ->        top_ord FOR ORDINALITY,
    ->        apath VARCHAR(10) PATH '$.a',
    ->        NESTED PATH '$.b[*]' COLUMNS (
    ->          bpath VARCHAR(10) PATH '$.c',
    ->          ord FOR ORDINALITY,
    ->          NESTED PATH '$.l[*]' COLUMNS (lpath varchar(10) PATH '$')
    ->          )
    ->      )
    ->  ) as jt;
+---------+-------+-------+------+-------+
| top_ord | apath | bpath | ord  | lpath |
+---------+-------+-------+------+-------+
|       1 | a_val | c_val |    1 | 1     |
|       1 | a_val | c_val |    1 | 2     |
|       2 | a_val | c_val |    1 | 11    |
|       2 | a_val | c_val |    2 | 22    |
+---------+-------+-------+------+-------+
4 rows in set (0.00 sec)

```

## JSON 实用程序函数

- JSON_PRETTY  漂亮打印

```sql
mysql> select json_pretty('[{"a": 1, "b": [11,111],"c": [33]}, {"a": 2, "b": [22,222]}]');
+---------------------------------------------------------------------------------------------------------------------------------------------------+
| json_pretty('[{"a": 1, "b": [11,111],"c": [33]}, {"a": 2, "b": [22,222]}]')                                                                       |
+---------------------------------------------------------------------------------------------------------------------------------------------------+
| [
  {
    "a": 1,
    "b": [
      11,
      111
    ],
    "c": [
      33
    ]
  },
  {
    "a": 2,
    "b": [
      22,
      222
    ]
  }
] |
+---------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

```

- JSON_STORAGE_FREE 对于[`JSON`](https://dev.mysql.com/doc/refman/8.0/en/json.html)列值，该功能显示多少存储空间

