#!/bin/bash
# author:apple
 
#EXEC_DATE=`date +%Y-%m-%d` 
EXEC_DATE=`date +'%Y-%m-%d %H:%M:%S'` 
TABLE_DATE=`date +%Y%m%d` 
FILE_DIR=`dirname $0` 
FILE_NAME=`basename $0 .sh` 
USER="root" 
PASSWORD="123456"
HOST="1.1.1.10" 

#主表归档  
sed '/^#.*\|^$/d' ${FILE_DIR}/${FILE_NAME}.def >${FILE_DIR}/${FILE_NAME}.tmp 
for i in `cat ${FILE_DIR}/${FILE_NAME}.tmp` 
do       
	#去空格,得到一行数据 
	DEF_DATA_TMP="`echo ${i} |sed s/\ //g`"
	SOURCE_DB=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"` 
	TABLE_NAME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"` 
	FLITER_FIELD=`echo ${i} | cut -d "," -f3 | tr "[A-Z]" "[a-z]"` 
	DEST_DB=`echo ${i} | cut -d "," -f4 | tr "[A-Z]" "[a-z]"` 
	FLITER_FIELD_JOIN=`echo ${i} | cut -d "," -f5 | tr "[A-Z]" "[a-z]"` 
	TABLE_NAME_JOIN=`echo ${i} | cut -d "," -f6 | tr "[A-Z]" "[a-z]"` 

	HISTABLE_NAME="${TABLE_NAME}_his${TABLE_DATE}" 
	HISTABLE_NAME_JOIN="${TABLE_NAME_JOIN}_his${TABLE_DATE}" 
        echo ${HISTABLE_NAME_JOIN}

	WHERE_SQL=`echo "'exec_time<\""${EXEC_DATE}" 00:00:00\"'"` 
	mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${HISTABLE_NAME} like ${SOURCE_DB}.${TABLE_NAME};" 
	mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${HISTABLE_NAME_JOIN} like ${SOURCE_DB}.${TABLE_NAME_JOIN};" 
	if [ $? -ne 0 ] ;then 
		echo "ERROR:create table ${HISTABLE_NAME} error!" >${FILE_DIR}/${FILE_NAME}.log 
		echo "ERROR:create table ${HISTABLE_NAME_JOIN} error!" >${FILE_DIR}/${FILE_NAME}.log 
	exit 1 
	fi 
  
	#echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --no-check-charset --where '${FLITER_FIELD}<\""${EXEC_DATE}" 00:00:00\"' --progress 5000 --limit=1000 --txn-size=1000 --statistics">pt-archiver-${TABLE_NAME}.sh 
	echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --no-check-charset --where '${FLITER_FIELD} < \"${EXEC_DATE}\"' --progress 5000 --limit=1000 --txn-size=1000 --statistics">pt-archiver-${TABLE_NAME}.sh 
	bash pt-archiver-${TABLE_NAME}.sh >pt-archiver-${TABLE_NAME}.log
 
	MAX_ID=`mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select max(id) from ${DEST_DB}.${HISTABLE_NAME};" | sed -n '2,$p'`
	echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME_JOIN} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME_JOIN} --no-check-charset --where '${FLITER_FIELD_JOIN} < ${MAX_ID}' --progress 5000 --limit=1000 --txn-size=1000 --statistics">pt-archiver-${TABLE_NAME_JOIN}.sh
	bash pt-archiver-${TABLE_NAME_JOIN}.sh >pt-archiver-${TABLE_NAME_JOIN}.log 
done 
exit 0

cat pt-archiver.def 
##源数据库名,源主表名,筛选字段,目标库名,备表筛选字段,备表名
db,t,updateTime,db,order_id,t_join


## 主表归档表ID不连续，order_date有错误数据 
#!/bin/bash
# author:apple
 
EXEC_DATE=`date +%Y-%m-%d` 
TABLE_DATE=`date +%Y%m%d` 
FILE_DIR=`dirname $0` 
FILE_NAME=`basename $0 .sh` 
USER="root" 
PASSWORD="123456"
HOST="1.1.1.10" 

#主表归档  
sed '/^#.*\|^$/d' ${FILE_DIR}/${FILE_NAME}.def >${FILE_DIR}/${FILE_NAME}.tmp 
for i in `cat ${FILE_DIR}/${FILE_NAME}.tmp` 
do       
	DEF_DATA_TMP="`echo ${i} |sed s/\ //g`"
	SOURCE_DB=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"` 
	TABLE_NAME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"` 
	FLITER_FIELD=`echo ${i} | cut -d "," -f3 | tr "[A-Z]" "[a-z]"` 
	DEST_DB=`echo ${i} | cut -d "," -f4 | tr "[A-Z]" "[a-z]"` 
	FLITER_FIELD_JOIN=`echo ${i} | cut -d "," -f5 | tr "[A-Z]" "[a-z]"` 
	TABLE_NAME_JOIN=`echo ${i} | cut -d "," -f6 | tr "[A-Z]" "[a-z]"` 
## 归档表命名规则
	HISTABLE_NAME="${TABLE_NAME}_his${TABLE_DATE}" 
	HISTABLE_NAME_JOIN="${TABLE_NAME_JOIN}_his${TABLE_DATE}" 

	WHERE_SQL=`echo "'exec_time<\""${EXEC_DATE}" 00:00:00\"'"` 
	mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${HISTABLE_NAME} like ${SOURCE_DB}.${TABLE_NAME};" 
	if [ $? -ne 0 ] ;then
        	echo "ERROR:create table ${HISTABLE_NAME} error!" >${FILE_DIR}/${FILE_NAME}.log
        exit 1
        fi

	mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${HISTABLE_NAME_JOIN} like ${SOURCE_DB}.${TABLE_NAME_JOIN};" 
	if [ $? -ne 0 ] ;then 
		echo "ERROR:create table ${HISTABLE_NAME_JOIN} error!" >${FILE_DIR}/${FILE_NAME}.log 
	exit 1 
	fi 
  
	echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --charset=UTF8 --where '${FLITER_FIELD} < unix_timestamp(\""${EXEC_DATE}" 00:00:00\") and ${FLITER_FIELD} != 2016' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert  --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME}.sh 
	bash pt-archiver-incre-${TABLE_NAME}.sh >pt-archiver-incre-${TABLE_NAME}.log
## 备表归档 
	if [ ${TABLE_NAME} = 'vgp_payment' ] ; then
	echo `mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select b.id from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${TABLE_NAME_JOIN} b where a.id = b.payment_id" | sed -n '2,$p'` > master_id_file
	else
	echo `mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select b.id from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${TABLE_NAME_JOIN} b where a.id = b.order_id" | sed -n '2,$p'` > master_id_file
 	fi

	for line in $(cat master_id_file)
	do
		echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME_JOIN} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME_JOIN} --charset=UTF8 --where '${FLITER_FIELD_JOIN}=${line}' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME_JOIN}.sh 
	bash pt-archiver-incre-${TABLE_NAME_JOIN}.sh >pt-archiver-incre-${TABLE_NAME_JOIN}.log 
	done
done 
exit 0

## 备表归档一行一行对比插入效率过慢，改变方式，并加入自动设置时间自动历史归档 
#!/bin/bash
# author:apple
 
#EXEC_DATE=`date +%Y-%m-%d` 
#TABLE_DATE=`date +%Y%m%d` 
FILE_DIR=`dirname $0` 
FILE_NAME=`basename $0 .sh` 
USER="root" 
PASSWORD="123456"
HOST="1.1.1.10"
 
sed '/^#.*\|^$/d' archiver_time.def > archiver_time.tmp 
for i in `cat archiver_time.tmp` 
do
	BEGIN_TIME=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"` 
	END_TIME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"`
	date -s "${END_TIME}"
	EXEC_DATE=`date +%Y-%m-%d`
	TABLE_DATE=`date +%Y%m%d` 
##主表归档  
	sed '/^#.*\|^$/d' ${FILE_DIR}/${FILE_NAME}.def >${FILE_DIR}/${FILE_NAME}.tmp 
	for i in `cat ${FILE_DIR}/${FILE_NAME}.tmp` 
	do       
	##	DEF_DATA_TMP="`echo ${i} |sed s/\ //g`"
	##	SOURCE_DB=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"` 
	##	TABLE_NAME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"` 
	##	FLITER_FIELD=`echo ${i} | cut -d "," -f3 | tr "[A-Z]" "[a-z]"` 
	##	DEST_DB=`echo ${i} | cut -d "," -f4 | tr "[A-Z]" "[a-z]"` 
	##	FLITER_FIELD_JOIN=`echo ${i} | cut -d "," -f5 | tr "[A-Z]" "[a-z]"` 
	##	TABLE_NAME_JOIN=`echo ${i} | cut -d "," -f6 | tr "[A-Z]" "[a-z]"` 
	## 归档表命名规则
	##	HISTABLE_NAME="${TABLE_NAME}_his${TABLE_DATE}" 
	##	HISTABLE_NAME_JOIN="${TABLE_NAME_JOIN}_his${TABLE_DATE}" 
	
		DEF_DATA_TMP="`echo ${i} |sed s/\ //g`"
		SOURCE_DB=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"`
		TABLE_NAME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"`
		FLITER_FIELD=`echo ${i} | cut -d "," -f3 | tr "[A-Z]" "[a-z]"`
		FLITER_FIELD_ID=`echo ${i} | cut -d "," -f4 | tr "[A-Z]" "[a-z]"`
		DEST_DB=`echo ${i} | cut -d "," -f5 | tr "[A-Z]" "[a-z]"`
		BACK_TABLE_NAME=`echo ${i} | cut -d "," -f6 | tr "[A-Z]" "[a-z]"`
		BACK_FLITER_FIELD=`echo ${i} | cut -d "," -f7 | tr "[A-Z]" "[a-z]"`
	## 归档表命名规则
		HISTABLE_NAME="${TABLE_NAME}_his${TABLE_DATE}"
		BACK_HISTABLE_NAME="${BACK_TABLE_NAME}_his${TABLE_DATE}"
	
		WHERE_SQL=`echo "'exec_time<\""${EXEC_DATE}" 00:00:00\"'"` 
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${HISTABLE_NAME} like ${SOURCE_DB}.${TABLE_NAME};" 
		if [ $? -ne 0 ] ;then
	        	echo "ERROR:create table ${HISTABLE_NAME} error!" >>${FILE_DIR}/${FILE_NAME}.log
	        exit 1
	        fi
	
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${BACK_HISTABLE_NAME} like ${SOURCE_DB}.${BACK_TABLE_NAME};" 
		if [ $? -ne 0 ] ;then 
			echo "ERROR:create table ${BACK_HISTABLE_NAME} error!" >>${FILE_DIR}/${FILE_NAME}.log 
		exit 1 
		fi 
	        echo `date +'%Y-%m-%d %H:%M:%S'` >> ${FILE_DIR}/${FILE_NAME}.log
		echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --charset=UTF8 --where '${FLITER_FIELD} >= unix_timestamp(\""${BEGIN_TIME}" 00:00:00\") and ${FLITER_FIELD} < unix_timestamp(\""${END_TIME}" 00:00:00\")' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert  --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME}.sh 
	##	echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --charset=UTF8 --where '${FLITER_FIELD} < unix_timestamp(\""${EXEC_DATE}" 00:00:00\")' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert  --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME}.sh 
		bash pt-archiver-incre-${TABLE_NAME}.sh >pt-archiver-incre-${TABLE_NAME}.log
	## 备表归档 
	##	if [ ${TABLE_NAME} = 'vgp_payment' ] ; then
	##	echo `mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select b.id from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${TABLE_NAME_JOIN} b where a.id = b.payment_id" | sed -n '2,$p'` > master_id_file
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "insert into ${DEST_DB}.${BACK_HISTABLE_NAME} (select b.* from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${BACK_TABLE_NAME} b where a.${FLITER_FIELD_ID} = b.${BACK_FLITER_FIELD});" >pt-archiver-incre-${BACK_TABLE_NAME}.log 
	##	else
	##	echo `mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select b.id from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${TABLE_NAME_JOIN} b where a.id = b.order_id" | sed -n '2,$p'` > master_id_file
	## 	fi
	
	##	for line in $(cat master_id_file)
	##	do
	##		echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME_JOIN} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME_JOIN} --charset=UTF8 --where '${FLITER_FIELD_JOIN}=${line}' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME_JOIN}.sh 
	##	bash pt-archiver-incre-${TABLE_NAME_JOIN}.sh >pt-archiver-incre-${TABLE_NAME_JOIN}.log 
	##	done
		echo `date +'%Y-%m-%d %H:%M:%S'` >> ${FILE_DIR}/${FILE_NAME}.log
	done
done
exit 0

cat pt-archiver_incre.def 
##源数据库名,源主表名,筛选字段,主表联表字段,目标库名,备表名，备表筛选字段
vingoo_icecream,vgp_order,order_date,id,vingoo_icecream,vgp_order_info,order_id
vingoo_icecream,vgp_order,order_date,id,vingoo_icecream,vgp_order_bom,order_id
vingoo_icecream,vgp_order,order_date,id,vingoo_icecream,vgp_monitor,order_id
vingoo_icecream,vgp_payment,order_date,id,vingoo_icecream,vgp_payment_info,payment_id

[root@datarchiver scripts]# cat archiver_time.def 
## 主表归档开始时间，备表归档结束时间
2013-01-01,2013-07-01
2013-07-01,2013-10-01
2013-10-01,2014-01-01
2014-01-01,2014-04-01
2014-04-01,2014-07-01
2014-07-01,2014-10-01
2014-10-01,2015-01-01
2015-01-01,2015-04-01
2015-04-01,2015-07-01
2015-07-01,2015-10-01
2015-10-01,2016-01-01
2016-01-01,2016-04-01
2016-04-01,2016-07-01
2016-07-01,2016-10-01
2016-10-01,2017-01-01
2017-01-01,2017-04-01
2017-04-01,2017-07-01

#删除源表的操作
cat pt-archiver_incre.sh 
#!/bin/bash
# author:apple
 
#EXEC_DATE=`date +%Y-%m-%d` 
#TABLE_DATE=`date +%Y%m%d` 
FILE_DIR=`dirname $0` 
FILE_NAME=`basename $0 .sh` 
USER="xxx" 
PASSWORD="xxx"
HOST="xxx"
 
sed '/^#.*\|^$/d' archiver_time.def > archiver_time.tmp 
for i in `cat archiver_time.tmp` 
do
	BEGIN_TIME=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"` 
	END_TIME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"`
	date -s "${END_TIME}"
	EXEC_DATE=`date +%Y-%m-%d`
	TABLE_DATE=`date +%Y%m%d` 
##主表归档  
	sed '/^#.*\|^$/d' ${FILE_DIR}/${FILE_NAME}.def >${FILE_DIR}/${FILE_NAME}.tmp 
	for i in `cat ${FILE_DIR}/${FILE_NAME}.tmp` 
	do       
	##	DEF_DATA_TMP="`echo ${i} |sed s/\ //g`"
	##	SOURCE_DB=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"` 
	##	TABLE_NAME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"` 
	##	FLITER_FIELD=`echo ${i} | cut -d "," -f3 | tr "[A-Z]" "[a-z]"` 
	##	DEST_DB=`echo ${i} | cut -d "," -f4 | tr "[A-Z]" "[a-z]"` 
	##	FLITER_FIELD_JOIN=`echo ${i} | cut -d "," -f5 | tr "[A-Z]" "[a-z]"` 
	##	TABLE_NAME_JOIN=`echo ${i} | cut -d "," -f6 | tr "[A-Z]" "[a-z]"` 
	## 归档表命名规则
	##	HISTABLE_NAME="${TABLE_NAME}_his${TABLE_DATE}" 
	##	HISTABLE_NAME_JOIN="${TABLE_NAME_JOIN}_his${TABLE_DATE}" 
	
		DEF_DATA_TMP="`echo ${i} |sed s/\ //g`"
		SOURCE_DB=`echo ${i} | cut -d "," -f1 | tr "[A-Z]" "[a-z]"`
		TABLE_NAME=`echo ${i} | cut -d "," -f2 | tr "[A-Z]" "[a-z]"`
		FLITER_FIELD=`echo ${i} | cut -d "," -f3 | tr "[A-Z]" "[a-z]"`
		FLITER_FIELD_ID=`echo ${i} | cut -d "," -f4 | tr "[A-Z]" "[a-z]"`
		DEST_DB=`echo ${i} | cut -d "," -f5 | tr "[A-Z]" "[a-z]"`
		BACK_TABLE_NAME=`echo ${i} | cut -d "," -f6 | tr "[A-Z]" "[a-z]"`
		BACK_FLITER_FIELD=`echo ${i} | cut -d "," -f7 | tr "[A-Z]" "[a-z]"`
	## 归档表命名规则
		HISTABLE_NAME="${TABLE_NAME}_his${TABLE_DATE}"
		BACK_HISTABLE_NAME="${BACK_TABLE_NAME}_his${TABLE_DATE}"
	
		WHERE_SQL=`echo "'exec_time<\""${EXEC_DATE}" 00:00:00\"'"` 
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${HISTABLE_NAME} like ${SOURCE_DB}.${TABLE_NAME};" 
		if [ $? -ne 0 ] ;then
	        	echo "ERROR:create table ${HISTABLE_NAME} error!" >>${FILE_DIR}/${FILE_NAME}.log
	        exit 1
	        fi
	
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "create table if not exists ${DEST_DB}.${BACK_HISTABLE_NAME} like ${SOURCE_DB}.${BACK_TABLE_NAME};" 
		if [ $? -ne 0 ] ;then 
			echo "ERROR:create table ${BACK_HISTABLE_NAME} error!" >>${FILE_DIR}/${FILE_NAME}.log 
		exit 1 
		fi 
	        echo `date +'%Y-%m-%d %H:%M:%S'` >> ${FILE_DIR}/${FILE_NAME}.log
		echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --charset=UTF8 --where '${FLITER_FIELD} >= unix_timestamp(\""${BEGIN_TIME}" 00:00:00\") and ${FLITER_FIELD} < unix_timestamp(\""${END_TIME}" 00:00:00\")' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert  --bulk-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME}.sh 
	##	echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME} --charset=UTF8 --where '${FLITER_FIELD} < unix_timestamp(\""${EXEC_DATE}" 00:00:00\")' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert  --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME}.sh 
		bash pt-archiver-incre-${TABLE_NAME}.sh >pt-archiver-incre-${TABLE_NAME}.log
	## 备表归档 
	##	if [ ${TABLE_NAME} = 'vgp_payment' ] ; then
	##	echo `mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select b.id from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${TABLE_NAME_JOIN} b where a.id = b.payment_id" | sed -n '2,$p'` > master_id_file
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "insert into ${DEST_DB}.${BACK_HISTABLE_NAME} (select b.* from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${BACK_TABLE_NAME} b where a.${FLITER_FIELD_ID} = b.${BACK_FLITER_FIELD});" >pt-archiver-incre-${BACK_TABLE_NAME}.log 
		mysql -h${HOST} -u${USER} -p${PASSWORD} -e "SET SQL_SAFE_UPDATES = 0;delete b.* from ${DEST_DB}.${HISTABLE_NAME} a ,${DEST_DB}.${BACK_TABLE_NAME} b where a.id = b.order_id;" >>pt-archiver-incre-${BACK_TABLE_NAME}.log 
	##	else
	##	echo `mysql -h${HOST} -u${USER} -p${PASSWORD} -e "select b.id from ${DEST_DB}.${HISTABLE_NAME} a,${DEST_DB}.${TABLE_NAME_JOIN} b where a.id = b.order_id" | sed -n '2,$p'` > master_id_file
	## 	fi
	
	##	for line in $(cat master_id_file)
	##	do
	##		echo " pt-archiver  --source h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${SOURCE_DB},t=${TABLE_NAME_JOIN} --dest h=${HOST},P=3306,u=${USER},p=${PASSWORD},D=${DEST_DB},t=${HISTABLE_NAME_JOIN} --charset=UTF8 --where '${FLITER_FIELD_JOIN}=${line}' --progress 5000 --limit=1000 --txn-size=1000 --statistics --bulk-insert --bulk-delete --no-delete --no-version-check ">pt-archiver-incre-${TABLE_NAME_JOIN}.sh 
	##	bash pt-archiver-incre-${TABLE_NAME_JOIN}.sh >pt-archiver-incre-${TABLE_NAME_JOIN}.log 
	##	done
		echo `date +'%Y-%m-%d %H:%M:%S'` >> ${FILE_DIR}/${FILE_NAME}.log
	done
done
exit 0
