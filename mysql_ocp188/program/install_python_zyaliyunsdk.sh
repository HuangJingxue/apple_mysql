#!/usr/bin/env bash

##############################################
# version: 1.0.0
# 0. 仅支持 CentOs 系统
# 1. 软件目录在 /alidata/install/zyaliyunsdk
##############################################


#检测 软件目录 是否存在
if [[ ! -f "/alidata/install/zyaliyunsdk" ]];then
mkdir -p /alidata/install/zyaliyunsdk
echo "Created /alidata/install/zyaliyunsdk"
fi

# 安装urllib3-1.25.3
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./urllib3-1.25.3.tar.gz" ]];then
echo "urllib3-1.25.3.tar.gz 存在"
tar zxvf urllib3-1.25.3.tar.gz
cd urllib3-1.25.3/
python3 setup.py build
python3 setup.py install
echo "### urllib3 install success!"
fi

# 安装xmltodict-0.12.0
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./xmltodict-0.12.0.tar.gz" ]];then
tar zxvf xmltodict-0.12.0.tar.gz
cd xmltodict-0.12.0/
python3 setup.py build
python3 setup.py install
echo "### xmltodict install success!"
fi

# 安装pbr-5.4.3
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./pbr-5.4.3.tar.gz" ]];then
tar zxvf pbr-5.4.3.tar.gz
cd pbr-5.4.3/
python3 setup.py build
python3 setup.py install
echo "### pbr install success!"
fi

# 安装retry-0.9.2
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./retry-0.9.2.tar.gz" ]];then
tar zxvf retry-0.9.2.tar.gz
cd retry-0.9.2/
python3 setup.py build
python3 setup.py install
echo "### retry install success!"
fi

# 安装chardet-3.0.4
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./chardet-3.0.4.tar.gz" ]];then
tar zxvf chardet-3.0.4.tar.gz
cd chardet-3.0.4/
python3 setup.py build
python3 setup.py install
echo "### chardet install success!"
fi

# 安装idna-2.8
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./idna-2.8.tar.gz" ]];then
tar zxvf idna-2.8.tar.gz
cd idna-2.8/
python3 setup.py build
python3 setup.py install
echo "### idna install success!"
fi

# 安装certifi-2019.9.11
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./certifi-2019.9.11.tar.gz" ]];then
tar zxvf certifi-2019.9.11.tar.gz
cd certifi-2019.9.11/
python3 setup.py build
python3 setup.py install
echo "### certifi install success!"
fi

# 安装decorator-4.4.0
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./decorator-4.4.0.tar.gz" ]];then
tar zxvf decorator-4.4.0.tar.gz
cd decorator-4.4.0/
python3 setup.py build
python3 setup.py install
echo "### decorator install success!"
fi

# 安装requests-2.22.0
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./requests-2.22.0.tar.gz" ]];then
tar zxvf requests-2.22.0.tar.gz
cd requests-2.22.0/
python3 setup.py build
python3 setup.py install
echo "### requests install success!"
fi

# 安装setuptools_scm-3.3.3
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./setuptools_scm-3.3.3.tar.gz" ]];then
tar zxvf setuptools_scm-3.3.3.tar.gz
cd setuptools_scm-3.3.3/
python3 setup.py build
python3 setup.py install
echo "### requests install success!"
fi

# 安装py-1.8.0
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./py-1.8.0.tar.gz" ]];then
tar zxvf py-1.8.0.tar.gz
cd py-1.8.0/
python3 setup.py build
python3 setup.py install
echo "### requests install success!"
fi

# 安装zy-aliyun-python-sdk
\cd /alidata/install/zyaliyunsdk/
if [[ -f "./zy-aliyun-python-sdk-0.0.5.tar.gz" ]];then
tar zxvf zy-aliyun-python-sdk-0.0.5.tar.gz
cd zy-aliyun-python-sdk-0.0.5/
python3 setup.py build
python3 setup.py install
echo "### zyaliyunpythonsdk install success!"
fi
