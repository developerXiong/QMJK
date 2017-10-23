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
    static func addUser(_ user: CYSubUserInfo, isSuccess: ((Bool, String)->())?) {
        /// 判断网络
        CYNetworkingRequest.monitorNetworking { (isNet) in
            if isNet {
                /// 添加服务器用户 
                addServerUser(user, isSuccess: { (isServerSuccess, errMsg) in
                    if isServerSuccess {
                        if isSuccess != nil {
                            isSuccess!(true, "")
                        }
                        /// 添加本地用户
                        addLocationUser(user, isSuccess: { (isLocationSuccess) in
                            
                        })
                    } else {
                        if isSuccess != nil {
                            isSuccess!(false, errMsg)
                        }
                    }
                })
            } else {
                if isSuccess != nil {
                    isSuccess!(false, "No network")
                }
            }
        }
    }
    
    /// 添加本地用户
    static func addLocationUser(_ user: CYSubUserInfo, isSuccess: ((Bool)->())?) {
        let db = CYDatabaseManager.shared
        let isLocationSuccess = db.insertData(subUser: user)
        if isSuccess != nil {
            isSuccess!(isLocationSuccess)
        }
    }
    
    /// 添加服务器用户
    static func addServerUser(_ user: CYSubUserInfo, isSuccess: ((Bool, String)->())?) {
        CYRequestHandler.addUser(userName: user.name!, sex: user.sex! ? 1 : 2, birth: user.birth!, height: Int(user.height!)!, weight: Int(user.weight!)!, infoLow: Int(user.lowBP!)!, InfoHigh: Int(user.highBP!)!, success: { (isServerSuccess, data) in
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
    static func updateUser(_ user: CYSubUserInfo, isSuccess: ((Bool, String)->())?) {
        // 判断网络
        CYNetworkingRequest.monitorNetworking { (isNet) in
            if isNet {
                /// 更新服务器用户资料
                self.updateServerUser(user, isSuccess: { (isServerSuccess, errMsg) in
                    if isServerSuccess {
                        if isSuccess != nil {
                            isSuccess!(true, "")
                        }
                        /// 更新本地用户
                        updateLocationUser(user, isSuccess: { (isLocationSuccess) in
                            
                        })
                    } else {
                        if isSuccess != nil {
                            isSuccess!(false, errMsg)
                        }
                    }
                })
            } else {
                if isSuccess != nil {
                    isSuccess!(false, "No network")
                }
            }
        }
    }
    
    /// 更新本地用户资料
    static func updateLocationUser(_ user: CYSubUserInfo, isSuccess: ((Bool)->())?) {
        let db = CYDatabaseManager.shared
        let isLocationSuccess = db.updateData(user: user)
        if isSuccess != nil {
            isSuccess!(isLocationSuccess)
        }
    }
    
    /// 更新服务器用户资料
    static func updateServerUser(_ user: CYSubUserInfo, isSuccess: ((Bool, String)->())?) {
        CYRequestHandler.modifyUser(String(user.sid!), userName: user.name!, sex: user.sex! ? 1 : 2, birth: user.birth!, height: Int(user.height!)!, weight: Int(user.weight!)!, infoLow: Int(user.lowBP!)!, InfoHigh: Int(user.highBP!)!, success: { (isServerSuccess, data) in
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
