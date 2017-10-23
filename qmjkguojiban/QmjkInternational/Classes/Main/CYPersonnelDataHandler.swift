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
    static func getSubUsers(_ isSuccess: (([CYUser]?, String)->())?) {
        getServerSubUsers({ (isServerSuccess, users, errMsg) in
            if isServerSuccess {
                if isSuccess != nil {
                    isSuccess!(users, errMsg)
                }
            } else {
                if isSuccess != nil {
                    isSuccess!(nil, "Request failure")
                }
            }
        })
    }

    /// 获取本地子用户列表
//    static func getLocationSubUsers() -> [CYSubUserInfo] {
//        let db = CYDatabaseManager.shared
//        var datas = [CYSubUserInfo]()
//        datas = db.readAllData(userId: Int64(USERID)!)
//        return datas
//    }
    
    /// 获取服务器子用户列表
    static func getServerSubUsers(_ isSuccess: ((Bool, [CYUser]?, String)->())?) {
        CYRequestHandler.getAllUser({ (isServerSuccess, data) in
            /*
             age = 27;
             birth = "1990-10-01";
             createTime = "2017-10-23 14:45:25";
             height = 170;
             id = 22;
             infoHigh = 125;
             infoLow = 75;
             lastUpdateInfoTime = "<null>";
             managerId = 24;
             sex = 1;
             userId = "a1094699-6b18-4539-ba02-913770e292e6";
             userName = cry;
             weight = 68;
             */
            if isServerSuccess {
                var result: [CYUser]? = nil
                if let users = data!["result"] as? [[String : Any]] {
                    result = CYUser.objectWithKeyValues(users) as? [CYUser]
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
