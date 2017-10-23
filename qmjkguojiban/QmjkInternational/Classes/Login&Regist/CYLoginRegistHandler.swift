//
//  CYLoginRegistHandler.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYLoginRegistHandler: NSObject {

    // MARK: Login
    
    /// 服务器登录
    static func loginServer(_ email: String, _ password: String, is_success: ((Bool, CYManager?, String)->())?) {
        CYRequestHandler.login(email, password: password, success: { (isSuccess, data) in
            if isSuccess {
                /// 登录成功
                guard let data = data else { return }
                var user = CYManager()
                let userId = data["managerId"]! as! String
                user.email = email
                user.password = password
                user.managerId = userId
                debugPrint("Login success")
                
                if is_success != nil {
                    is_success!(true, user, "")
                }
                
            } else {
                /// 登录失败
                if is_success != nil {
                    is_success!(false, nil, "User is not exist")
                }
            }
        }) { (error) in
            /// 登录失败
            if is_success != nil {
                is_success!(false, nil, "Request failure")
            }
        }
    }
    
    /// 本地登录
//    static func loginLocation(_ email: String, _ password: String, isSuccess: ((Bool, CYUserInfo?)->())?) {
//        let db = CYDatabaseManager.shared
//        let user = db.readAData(_email: email, _password: password)
//
//        if user != nil {
//            if isSuccess != nil {
//                isSuccess!(true, user!)
//            }
//        } else {
//            if isSuccess != nil {
//                isSuccess!(false, nil)
//            }
//        }
//    }
    
    /// 登录全民健康
    static func loginQmjk(_ account: String, isSuccess: ((Bool, String)->())?) {
        QmjkRegisterHttpHandler.login(withAccount: account, success: { (response) in
            let resp = response as! [AnyHashable : Any]
            let errorMsg = resp["errorMsg"] as! String
            if isSuccess != nil {
                if errorMsg.isEmpty {
                    debugPrint("登录qmjk成功:\(response!)")
                    isSuccess!(true, "Login success")
                } else {
                    debugPrint("登录qmjk失败: \(errorMsg)")
                    isSuccess!(false, "Login Failure," + errorMsg)
                }
            }
        }) { (error) in
            debugPrint("登录qmjk错误: \(error!)")
            if isSuccess != nil {
                isSuccess!(false, "Login failure, Request failure")
            }
        }
    }
    
    // MARK: Reguster
    
    /// 走服务器注册
    static func registServer(_ email: String, _ password: String, is_success:((Bool, String)->())?) {
        CYRequestHandler.regist(email, password, success: { (isSuccess, data) in
            debugPrint(data ?? "注册无返回值")
            if (is_success != nil) {
                is_success!(isSuccess, "")
            }
        }) { (error) in
            if is_success != nil {
                is_success!(false, "Request failure")
            }
        }
    }
    
    /// 走本地注册
//    static func registLocation(_ email: String, _ password: String, isSuccess:((Bool, String)->())?) {
//        let db = CYDatabaseManager.shared
//        let is_success = db.insertData(_password: password, _email: email, _isUpload: true)
//        if isSuccess != nil {
//            isSuccess!(is_success, is_success ? "" : "插入数据库失败")
//        }
//    }
    
    /// 注册全民健康sdk账号
    static func registQmjk(_ account: String, isSuccess:((Bool, String)->())?) {
        var params = [String: Any]()
        params["userAccount"] = account
        params["sex"] = "1"
        params["birth"] = "1990-01-01"
        params["height"] = "178"
        params["weight"] = "66"
        params["infoLow"] = "70"
        params["infoHigh"] = "110"
        params["infoBPSituation"] = "2"
        QmjkRegisterHttpHandler.addUserInfo(params, success: { (response) in
            let data = response as! [String : Any]
            let errorMsg = data["errorMsg"] as! String
            if errorMsg.isEmpty {
                /// 注册全民健康账号成功
                if isSuccess != nil {
                    isSuccess!(true, errorMsg)
                }
                debugPrint("注册全民健康账号成功")
            } else {
                /// 注册全民健康账号失败
                if isSuccess != nil {
                    isSuccess!(false, errorMsg)
                }
                debugPrint("注册全民健康账号失败")
            }
        }) { (error) in
            /// 注册全民健康账号失败
            if isSuccess != nil {
                isSuccess!(false, "Request failure")
            }
            debugPrint("注册全民健康账号失败")
        }
    }
    
    
}
