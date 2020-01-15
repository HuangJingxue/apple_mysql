#!/bin/bash
/bin/python3 /alidata/scripts/check_mysql_repliction_slave.py
/bin/python3 /alidata/scripts/slb_auto_modify_weight.py --RoleName AIA-SLB-Ops-Ods-Prod-Limit-access --LoadBalancerId lb-pz5ldmucsqbl51h5ctnii --Region cn-shanghai-finance-1
