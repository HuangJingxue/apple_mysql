#!/usr/bin/env bash

##############################################
# version: 1.0.0
# 0. python version 3.7.3
# 1. 仅支持 CentOs 系统
# 2. 安装根目录在 /alidata/
##############################################
if [[ -f "/usr/bin/python3" ]]; then
    exit
fi

# 安装系统依赖包
yum -y install zlib-devel bzip2 bzip2-devel openssl openssl-static openssl-devel \
ncurses ncurses-devel sqlite sqlite-devel readline readline-devel tk tk-devel lzma gdbm \
gdbm-devel db4-devel libpcap-devel xz xz-devel libffi-devel gcc

#检测 cloudcare 是否存在
if [[ ! -f "/alidata" ]];then
mkdir /alidata
echo "Created /alidata"
fi

# 下载安装包 python 3.7.3
\cd /alidata/install/zyaliyunsdk/
if [[ ! -f "./Python-3.7.3.tgz" ]];then
echo "Python-3.7.3.tgz 存在"
fi


# 解压文件
tar -xvf Python-3.7.3.tgz && cd Python-3.7.3/

# 编译 python 包
./configure --prefix=/alidata/python3
make && make install && echo "### Python3 install success!"

# 创建软连接
ln -s /alidata/python3/bin/python3 /usr/bin/python3 && echo "### Add python3 link Done!"


ln -s /alidata/python3/bin/pip3 /usr/bin/pip3
