- [下载](https://www.percona.com/downloads/Percona-XtraBackup-2.4/LATEST/)
- [安装向导](https://www.percona.com/doc/percona-xtrabackup/2.4/installation/yum_repo.html)

install.sh
```shell
wget https://www.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.18/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.18-1.el7.x86_64.rpm
yum localinstall percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm
```
uninstall.sh
```shell
yum remove percona-xtrabackup
```
