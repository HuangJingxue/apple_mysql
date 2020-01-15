# -*- coding: utf-8 -*-

"""
自动修改默认服务器组的权重
https://help.aliyun.com/document_detail/104118.html?spm=5176.10695662.1996646101.searchclickresult.3bea185c795JRq&aly_as=BRPM57wP
"""
# Build-in Modules
import sys
import json
import datetime
import argparse
import logging
import config
from aliyun_sdk import client

common_region_ids = []

# 设置程序日志
log_dir = config.log_dir
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    datefmt='%a, %d %b %Y %H:%M:%S',
                    filename='{0}/slb.log'.format(log_dir),
                    filemode='a')


class Custom:
    def __init__(self):
        pass

    def GetConfig(self, **kwargs):
        self.out = kwargs
        self.aliyun = client.AliyunClient(config=kwargs)

    def get_DescribeLoadBalancerAttribute(self, LoadBalancerId, Region):
        # slb实例明细
        instance_list = []

        try:
            status_code, api_res = self.aliyun.common("slb", Action="DescribeLoadBalancerAttribute",
                                                      RegionId=Region,
                                                      LoadBalancerId=LoadBalancerId)
            logging.info(json.dumps(api_res, indent=2))
        except Exception as e:
            logging.info(str(e))
        else:
            instance_weight_info = list(api_res.get("BackendServers", {}).get("BackendServer", []))
            instance_list = instance_list + list(map(
                lambda x: {"ServerId": x.get("ServerId")},
                instance_weight_info))

        logging.info(instance_list)
        logging.info(instance_weight_info)
        return instance_list, instance_weight_info

    def set_SetBackendServers(self, LoadBalancerId, Region, BackendServers):
        """
        设置权重
        :return:
        """
        try:
            status_code, api_res = self.aliyun.common("slb", Action="SetBackendServers",
                                                      RegionId=Region,
                                                      BackendServers=BackendServers,
                                                      LoadBalancerId=LoadBalancerId)
            logging.info(json.dumps(api_res, indent=2))
        except Exception as e:
            logging.info(str(e))

    def main(self, **kwargs):
        LoadBalancerId, Region = kwargs["LoadBalancerId"], kwargs["Region"]
        instance_list, instance_weight_info = self.get_DescribeLoadBalancerAttribute(LoadBalancerId, Region)

        if len(instance_list) != 2:
            exit()
            logging.info("必须为两台服务器")
        BackendServers = []
        for backend_server in instance_weight_info:
            if backend_server["Weight"] == 100:
                backend_server["Weight"] = 0
            else:
                backend_server["Weight"] = 100

            BackendServers.append(backend_server)

        logging.info(BackendServers)
        self.set_SetBackendServers(LoadBalancerId, Region, json.dumps(BackendServers))

        return BackendServers


if __name__ == "__main__":
    """
    ==========================================================================================
    修改于2019-09-18（by ruijie.qiao）: 添加API STS请求验证功能。
    需要更新库版本至最新版本（version:0.0.5）: pip3 install --upgrade zy-aliyun-python-sdk 
    请求参数案例1（默认AK传空值为STS Token验证方式，RoleName为空的默认值为ZhuyunFullReadOnlyAccess）:
            'AccessKeyId': None,
            'AccessKeySecret': None,
            'RoleName': None,
    请求参数案例2（AK值不为空的时候，为普通的AK验证方式，这时候如果RoleName为非空，STS Token验证方式也不生效）:
            'AccessKeyId': XXXXXXXXXXXXXX,
            'AccessKeySecret': XXXXXXXXXXXXXX,
            'RoleName': None,
    请求参数案例3（默认AK传空值为STS Token验证方式，RoleName不为空，RoleName为设置的值）:
            'AccessKeyId': None,
            'AccessKeySecret': None,
            'RoleName': XXXXXXXXXXXXXX,
    ==========================================================================================
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("--AccessKeyId", help="AccessKeyId 非必要参数")
    parser.add_argument("--AccessKeySecret", help="AccessKeySecret 非必要参数")
    parser.add_argument("--RoleName", help="RoleName 非必要参数")
    parser.add_argument("--Region", help="指定地域")
    parser.add_argument("--LoadBalancerId", help="slb实例id")


    args = parser.parse_args()


    # "cn-qingdao",
    # "cn-beijing",
    # "cn-zhangjiakou",
    # "cn-huhehaote",
    # "cn-hangzhou",
    # "cn-shanghai",
    # "cn-shenzhen",
    # "cn-hongkong",
    # "cn-shanghai-finance-1",
    # "cn-shenzhen-finance-1",
    # "cn-qindao-finance-1"



    if args.LoadBalancerId:
        params = {
            'AccessKeyId': args.AccessKeyId,
            'AccessKeySecret': args.AccessKeySecret,
            'RoleName': args.RoleName,
        }

        api = Custom()
        api.GetConfig(**params)
        main_params = {
            "LoadBalancerId": args.LoadBalancerId,
            "Region": args.Region,
        }
        api.main(**main_params)

"""
python3 slb_auto_modify_weight.py --AccessKeyId AccessKeyId --AccessKeySecret AccessKeySecret --LoadBalancerId lb-pz5ldmucsqbl51h5ctnii --Region cn-shanghai-finance-1
"""
