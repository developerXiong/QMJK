//
//  CYHistoryHandler.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryHandler: NSObject {

    /// 获取体检记录
    static func getHistory(_ userId: Int64, isSuccess: (([CYHistory])->())?) {
        /// 判断网络情况
        CYNetworkingRequest.monitorNetworking { (isNetwork) in
            if isNetwork {
                getServerHistory(userId, isSuccess: { (isServerSuccess, users, errMsg) in
                    if isServerSuccess {
                        if isSuccess != nil {
                            isSuccess!(users!)
                        }
                    } else {
                        if isSuccess != nil {
                            isSuccess!(getLocationHistory(userId))
                        }
                    }
                })
            } else {
                /// 网络不好直接走本地
                if isSuccess != nil {
                    isSuccess!(getLocationHistory(userId))
                }
            }
        }
    }
    
    /// 获取本地体检记录
    static func getLocationHistory(_ userId: Int64) -> [CYHistory] {
        let db = CYDatabaseManager.shared
        var datas = [CYHistory]()
        datas = db.readAllData(sid: userId)
        return datas
    }
    
    /// 获取服务器体检记录到
    static func getServerHistory(_ userId: Int64, isSuccess: ((Bool, [CYHistory]?, String)->())?) {
        CYRequestHandler.getHistoryRecord(String(userId), success: { (isServerSuccess, data) in
            
            if isServerSuccess {
                let users = data!["history"] as! [[String : Any]]
                let result = CYHistory.mj_objectArray(withKeyValuesArray: users)
                if isSuccess != nil {
                    isSuccess!(isServerSuccess, result as? [CYHistory], "")
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
