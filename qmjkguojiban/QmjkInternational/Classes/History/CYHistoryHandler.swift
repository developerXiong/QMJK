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
    static func getHistory(_ userId: String, isSuccess: (([CYHistory]?, String)->())?) {
        getServerHistory(userId) { (is_success, history, errMsg) in
            if isSuccess != nil {
                if is_success {
                    isSuccess!(history, errMsg)
                } else {
                    isSuccess!(nil, "Request failure")
                }
            }
        }
        
    }
    
    /// 获取本地体检记录
//    static func getLocationHistory(_ userId: Int64) -> [CYHistory] {
//        let db = CYDatabaseManager.shared
//        var datas = [CYHistory]()
//        datas = db.readAllData(sid: userId)
//        return datas
//    }
    
    /// 获取服务器体检记录到
    static func getServerHistory(_ userId: String, isSuccess: ((Bool, [CYHistory]?, String)->())?) {
        CYRequestHandler.getHistoryRecord(String(userId), success: { (isServerSuccess, data) in
            
            if isServerSuccess {
                var result: [CYHistory]? = nil
                if let users = data!["result"] as? [[String : Any]] {
                    result = CYHistory.objectWithKeyValues(users) as? [CYHistory]
                }
                if isSuccess != nil {
                    isSuccess!(isServerSuccess, result, "")
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
