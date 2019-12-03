```sql
mysql>select ROUTINE_SCHEMA,ROUTINE_NAME,DEFINER from information_schema.routines;
+--------------------------+------------------------+-------------------+
| ROUTINE_SCHEMA           | ROUTINE_NAME           | DEFINER           |
+--------------------------+------------------------+-------------------+
| ilead                    | getFuncChildLst        | xtepali_rds@%     |
| ilead                    | getFuncChildLst_t      | xtepali_rds@%     |
| ilead                    | getGroupChildLst       | xtepali_rds@%     |
| ilead                    | getOrgChildLst         | xtepali_rds@%     |
| ilead                    | getOrgParentLst        | xtepali_rds@%     |
| ilead                    | getRoleChildLst        | xtepali_rds@%     |
| orders_ismp_0016         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0017         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0018         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0019         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0020         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0021         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0022         | nextSeqValue           | zyadmin_super@%   |
| orders_ismp_0023         | nextSeqValue           | zyadmin_super@%   |
+--------------------------+------------------------+-------------------+
返回行数：[14]，耗时：7 ms.
mysql>select trigger_schema,trigger_name,definer from information_schema.triggers;
+--------------------------+-----------------------------------------------+-------------------+
| trigger_schema           | trigger_name                                  | definer           |
+--------------------------+-----------------------------------------------+-------------------+
| orders_ismp_0020         | pt_osc_orders_ismp_0020_or_ud_ticket_et_1_ins | zyadmin_orders@%  |
| orders_ismp_0020         | pt_osc_orders_ismp_0020_or_ud_ticket_et_1_upd | zyadmin_orders@%  |
| orders_ismp_0020         | pt_osc_orders_ismp_0020_or_ud_ticket_et_1_del | zyadmin_orders@%  |
+--------------------------+-----------------------------------------------+-------------------+
返回行数：[3]，耗时：31 ms.
mysql>select table_schema,table_name,definer from views;
mysql>select table_schema,table_name,definer from information_schema.views;
+------------------------+----------------------+-------------------+
| table_schema           | table_name           | definer           |
+------------------------+----------------------+-------------------+
返回行数：[0]，耗时：31 ms.
mysql>select trigger_schema,trigger_name,definer from information_schema.triggers;
+--------------------------+------------------------+-------------------+
| trigger_schema           | trigger_name           | definer           |
+--------------------------+------------------------+-------------------+
返回行数：[0]，耗时：39 ms.
```
