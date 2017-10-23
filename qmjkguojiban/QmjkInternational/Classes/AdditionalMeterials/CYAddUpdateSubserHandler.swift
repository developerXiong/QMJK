//
//  CYAddUpdateSubserHandler.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddUpdateSubserHandler: NSObject {

    // MARK: 添加
    
    /// 添加用户
    static func addUser(_ user: CYUser, isSuccess: ((Bool, String)->())?) {
        /// 添加服务器用户
        addServerUser(user, isSuccess: { (isServerSuccess, errMsg) in
            if isSuccess != nil {
                isSuccess!(isServerSuccess, errMsg)
            }
        })
    }
    
    /// 添加本地用户
//    static func addLocationUser(_ user: CYUser, isSuccess: ((Bool)->())?) {
//        let db = CYDatabaseManager.shared
//        let isLocationSuccess = db.insertData(subUser: user)
//        if isSuccess != nil {
//            isSuccess!(isLocationSuccess)
//        }
//    }
    
    /// 添加服务器用户
    static func addServerUser(_ user: CYUser, isSuccess: ((Bool, String)->())?) {
        CYRequestHandler.addUser(userName: user.userName!, sex: user.sex!, birth: user.birth!, height: Int(user.height!)!, weight: Int(user.weight!)!, infoLow: Int(user.infoLow!)!, InfoHigh: Int(user.infoHigh!)!, success: { (isServerSuccess, data) in
            if isSuccess != nil {
                isSuccess!(isServerSuccess, String(describing: data!["errorMsg"]))
            }
        }) { (error) in
            if isSuccess != nil {
                isSuccess!(false, "Request failure")
            }
        }
    }
    
    // MARK: 更新
    
    /// 更新用户资料
    static func updateUser(_ user: CYUser, isSuccess: ((Bool, String)->())?) {
        /// 更新服务器用户资料
        self.updateServerUser(user, isSuccess: { (isServerSuccess, errMsg) in
            if isSuccess != nil {
                isSuccess!(isServerSuccess, errMsg)
            }
        })
    }
    
    /// 更新本地用户资料
//    static func updateLocationUser(_ user: CYUser, isSuccess: ((Bool)->())?) {
//        let db = CYDatabaseManager.shared
//        let isLocationSuccess = db.updateData(user: user)
//        if isSuccess != nil {
//            isSuccess!(isLocationSuccess)
//        }
//    }
    
    /// 更新服务器用户资料
    static func updateServerUser(_ user: CYUser, isSuccess: ((Bool, String)->())?) {
        CYRequestHandler.modifyUser(String(user.userId!), userName: user.userName!, sex: user.sex!, birth: user.birth!, height: Int(user.height!)!, weight: Int(user.weight!)!, infoLow: Int(user.infoLow!)!, InfoHigh: Int(user.infoHigh!)!, success: { (isServerSuccess, data) in
            if isSuccess != nil {
                isSuccess!(isServerSuccess, String(describing: data!["errorMsg"]))
            }
        }) { (errMsg) in
            if isSuccess != nil {
                isSuccess!(false, "Request failure")
            }
        }
    }
    
}
