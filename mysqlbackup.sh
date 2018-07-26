#!/bin/bash
#Do not forget change the password

check_mod()
{
	if [ -w $1 ];
	then
		echo "${1} dir could be write\r\n"
	else
		chmod 700 $1
		echo "${1} dir can not write,do the chmod 700\r\n"
	fi
}

make_path()
{
	mkdir $1
	chmod 700 $1
	echo "${1} dir is not exist,create the dir and chmod to 700\r\n"
}

data_path_root="/local/mntdir/dbback"
date_year=$(date +%y)
date_month=$(date +%m)
date_day=$(date +%d)

if [ -d $data_path_root ];
then
	check_mod $data_path_root
else
	make_path $data_path_root;
fi

year_path=${data_path_root}/${date_year}

if [ -d $year_path ];
then
	check_mod $year_path
else
	make_path $year_path
fi

month_path=${year_path}/${date_month}
if [ -d $month_path ];
then
	check_mod $month_path
else
	make_path $month_path
fi

day_path=${month_path}/${date_day}
if [ -d $day_path ];
then
	check_mod $day_path
else
	make_path $day_path
fi

full_path=${day_path}/$(date +%y_%m_%d_%H_%M)
echo ${year_path}
/usr/bin/mysqldump  -hXXX -uXXX --ignore-table=pro_bankhscf.hs_aleve_log --ignore-table=pro_bankhscf.hs_request_log --ignore-table=pro_bankhscf.hs_aleve_log_17_1 --ignore-table=pro_bankhscf.hs_aleve_log_17_2 --ignore-table=pro_bankhscf.hs_aleve_log_17_3 --ignore-table=pro_bankhscf.hs_aleve_log_17_4 --ignore-table=pro_bankhscf.hs_eve_log_17_1 --ignore-table=pro_bankhscf.hs_eve_log_17_2 --ignore-table=pro_bankhscf.hs_eve_log_17_3 --ignore-table=pro_bankhscf.hs_eve_log_17_4 --ignore-table=pro_bankhscf.hs_app_log --ignore-table=pro_bankhscf.hs_send_email --ignore-table=pro_bankhscf.hs_send_sms --ignore-table=pro_bankhscf.hs_admin_log -p"xxx" pro_bankhscf | zip > ${full_path}.zip
