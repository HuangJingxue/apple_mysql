#!/bin/bash
#author:apple
#date:2018-07-11
#version:1.0
#update version:2018-07-18 1.1

find . -type f -name "MySQL-01-relay-bin.*[0-9]" -mtime +3 -exec  ls {} \; > relay_log_file
for i in `cat relay_log_file`
do
	for j in `cat MySQL-01-relay-bin.index`
	do
		if [ "$i" == "$j" ]
		then
			reg_str=`echo $j | sed 's@\/@\\\/@g'`
			sed -i "/$reg_str/d" MySQL-01-relay-bin.index
		fi
	done
done
find . -type f -name "MySQL-01-relay-bin.*[0-9]" -mtime +3 -exec  rm -rf {} \;
