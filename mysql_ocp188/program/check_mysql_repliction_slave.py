#!/bin/python3
# coding: utf-8

import time
import datetime
import sys
import os
import decimal
import logging
import json

# Third-part
import filelock
import pymysql
import config

# 设置程序日志
log_dir = config.log_dir
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    datefmt='%a, %d %b %Y %H:%M:%S',
                    filename='{0}/mysql_consistent.log'.format(log_dir),
                    filemode='a')

# 定义json特殊处理类
class CJsonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            return obj.strftime('%Y-%m-%d %H:%M:%S')
        if isinstance(obj, decimal.Decimal):
            return str(obj)
        else:
            return json.JSONEncoder.default(self, obj)

# 定义MySQL数据连接类
class MysqlHelper:
    def __init__(self, **kwargs):
        self.url = kwargs['url']
        self.port = kwargs['port']
        self.username = kwargs['username']
        self.password = kwargs['password']
        self.dbname = kwargs['dbname']
        self.charset = "utf8"
        try:
            self.conn = pymysql.connect(host=self.url, user=self.username, passwd=self.password, port=self.port,
                                    charset=self.charset, db=self.dbname)
            self.cur = self.conn.cursor(cursor=pymysql.cursors.DictCursor)
        except Exception as e:
            logging.info(str(e))

    def col_query(self, sql):
        """
        打印表的列名
        :return list
        """
        self.cur.execute(sql)
        return self.cur.fetchall()

    def commit(self):
        self.conn.commit()

    def close(self):
        self.cur.close()
        self.conn.close()


class Check:
    def __init__(self, **kwargs):
        self.params = kwargs
        try:
            self.conn = MysqlHelper(**self.params)
        except Exception as e:
            #logging.info("数据库连接异常 " + str(e))
            exit(1)


    def start(self):
        """
        将从库切换为主库
        1. 获取从库slave状态
        2. 判断主从是否存在延迟
        3. 如存在延迟自动补数据
        :return:
        """
        slave_status = self.conn.col_query("show slave status")[0]
        #slave_status = {'Master_Host':'10.10','Relay_Master_Log_File':'mybinlog.000098','Exec_Master_Log_Pos':'191'}
        #logging.info(json.dumps(slave_status, indent=2))
        Master_Host = slave_status["Master_Host"]
        # Master_Log_File = slave_status["Master_Log_File"]
        # Read_Master_Log_Pos = slave_status["Read_Master_Log_Pos"]
        Relay_Master_Log_File = slave_status["Relay_Master_Log_File"]
        Exec_Master_Log_Pos = slave_status["Exec_Master_Log_Pos"]

        # 记录主库真实的binlog文件和position编号
        try:
            master_binlog_file_real = \
                open("/alidata/mysql/data/mybinlog.index").readlines()[-1].strip()
            cmd = "/alidata/mysql/bin/mysqlbinlog -vv " + "/alidata/mysql/data/" + master_binlog_file_real + " | tail -n 100|grep end_log_pos|tail -n 2|head -n 1|awk '{print $7}'"
            master_binlog_pos_real = os.popen(cmd).read()
        except Exception as e:
           # logging.error(str(e))
           logging.info(str(e))

        else:
            logging.info("主库 {0} 最后一个binlog日志文件 {1}  位置编号为 {2}".format(Master_Host, master_binlog_file_real,
                                                                       master_binlog_pos_real))
            logging.info("从库 {0} 重演主库binlog日志文件 {1}  位置编号为 {2}".format(
                self.params["url"],
                slave_status["Relay_Master_Log_File"],
                slave_status["Exec_Master_Log_Pos"]))

        """
        判断主从数据是否不一致
        1、f1 = f2 and p1 = p2 则说明主从是一致的
        2、f1 = f2 and p1 > p2 则说明主从有延迟，需要补f2.p2一直到最后
        3、f1 > f2             则说明主从有较大的延迟，需要补f2.p2一直到最后，多份binlog 
        """
        _f1 = int(master_binlog_file_real.split('mybinlog.')[1])
        f1 = master_binlog_file_real
        _f2 = int(slave_status["Relay_Master_Log_File"].split('mybinlog.')[1])
        f2 = slave_status["Relay_Master_Log_File"]
        p1 = int(master_binlog_pos_real)
        p2 = int(slave_status["Exec_Master_Log_Pos"])

        if _f1 == _f2 and p1 == p2:
            logging.info("主从无延迟")
        if _f1 == _f2 and p1 > p2:
            logging.info("主从有延迟，需要回放数据")
            cmd = "/alidata/mysql/bin/mysqlbinlog -vv /alidata/mysql/data/{f2} --start-position={p2} | mysql -u{user} -p{password} -h{host}".format(
                f2=f2,
                p2=p2,
                user=self.params['username'],
                password=self.params['password'],
                host=self.params['url']
            )
            logging.info(cmd)
            cmd_result = os.popen(cmd).read()
            logging.info(cmd_result)
        if _f1 > _f2:
            logging.info("主从有较大延迟，需要回放数据")
            a = os.popen("sed -n '/{}/,$p' /alidata/mysql/data/mybinlog.index".format(f2)).read()
            a_list = a.strip().split('\n')
            #['./mybinlog.000091', './mybinlog.000092', './mybinlog.000093', './mybinlog.000094', './mybinlog.000095','./mybinlog.000096']
            cmd = "/alidata/mysql/bin/mysqlbinlog -vv /alidata/mysql/data/{f2} --start-position={p2} | mysql -u{user} -p{password} -h{host}".format(
                f2=a_list[0],
                p2=p2,
                user=self.params['username'],
                password=self.params['password'],
                host=self.params['url']
            )
            logging.info(cmd)
            cmd_result = os.popen(cmd).read()
            logging.info(cmd_result)
            for i in a_list[1:]:
                cmd = "/alidata/mysql/bin/mysqlbinlog -vv /alidata/mysql/data/{f2}  | mysql -u{user} -p{password} -h{host}".format(
                    f2=i,
                    p2=p2,
                    user=self.params['username'],
                    password=self.params['password'],
                    host=self.params['url']
                )
                logging.info(cmd)
                cmd_result = os.popen(cmd).read()
                logging.info(cmd_result)


if __name__ == "__main__":
    params = {
        "url": config.dbhost,
        "port": config.dbport,
        "username": config.dbuser,
        "password": config.dbpassword,
        "dbname": "mysql",
    }

    

    db = Check(**params)
    db.start()
