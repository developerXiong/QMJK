//
//  CYPersonnelDataHandler.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYPersonnelDataHandler: NSObject {
    
    /// 获取所有子用户资料
    static func getSubUsers(_ isSuccess: (([CYSubUserInfo])->())?) {
        /// 判断网络情况
        CYNetworkingRequest.monitorNetworking { (isNetwork) in
            if isNetwork {
                getServerSubUsers({ (isServerSuccess, users, errMsg) in
                    if isServerSuccess {
                        if isSuccess != nil {
                            isSuccess!(users!)
                        }
                    } else {
                        if isSuccess != nil {
                            isSuccess!(getLocationSubUsers())
                        }
                    }
                })
            } else {
                /// 网络不好直接走本地 
                if isSuccess != nil {
                    isSuccess!(getLocationSubUsers())
                }
            }
        }
    }

    /// 获取本地子用户列表
    static func getLocationSubUsers() -> [CYSubUserInfo] {
        let db = CYDatabaseManager.shared
        var datas = [CYSubUserInfo]()
        datas = db.readAllData(userId: Int64(USERID)!)
        return datas
    }
    
    /// 获取服务器子用户列表
    static func getServerSubUsers(_ isSuccess: ((Bool, [CYSubUserInfo]?, String)->())?) {
        CYRequestHandler.getAllUser({ (isServerSuccess, data) in
            
            if isServerSuccess {
                let users = data!["users"] as! [[String : Any]]
                let result = CYSubUserInfo.mj_objectArray(withKeyValuesArray: users)
                if isSuccess != nil {
                    isSuccess!(isServerSuccess, result as? [CYSubUserInfo], "")
                }
            } else {
                if isSuccess != nil {
                    isSuccess!(isServerSuccess, nil, String(describing: data!["errorMsg"]))
                }
            }
            
        }) { (error) in
            if isSuccess != nil {
                isSuccess!(false, nil, "Request failure")
            }
        }
    }
    
}
