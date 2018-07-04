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

