//
//  CYRequestHandler.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/26.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYRequestHandler: NSObject {

    typealias RequestSuccessBlock = (Bool, [String : Any]?) -> ()
    typealias RequestFailureBlock = (String) -> ()
    
    /// 注册
    static func regist(_ account: String, _ password: String, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["userAccount" : account, "password" : password]
        let url = "addUserManager"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    /// 登录
    /// 返回：
    /// {"status":200,"isLogin":true,"managerId":1}
    static func login(_ account: String, password: String, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["userAccount" : account, "password" : password]
        let url = "login"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = data!["isLogin"] as! Bool
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    /// 上传体检记录
//    uploadUserData
//    JSONObject :
//    userId:String//用户id
//    rate:int
//    oxygen:int
//    lowPressure:int
//    highPressure:int
//    pi:int
//    breath:int
//    pwtt:double
//    awx:double
//    waveWidth:double
//    deviceId:String //设备id
    static func uploadTestRecord(_ userId: String, _ rate: Int, _ oxygen: Int, _ low: Int, _ high: Int, _ PI: Int, _ breath: Int, _ deviceId: String, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["userId": userId, "rate": rate, "oxygen": oxygen, "lowPressure": low, "highPressure": high, "pi": PI, "breath": breath, "deviceId": deviceId] as [String : Any]
        let url = "uploadUserData"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    /// 获取历史记录
    static func getHistoryRecord(_ userId: String, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["userId": userId]
        let url = "getUserDataByUserid"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    /// 添加新用户
    static func addUser(userName: String,sex: String,birth: String,height: Int, weight: Int, infoLow:Int, InfoHigh: Int, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["managerId": MANAGER_ID, "userName": userName, "sex": sex, "birth": birth, "height": height, "weight": weight, "infoLow": infoLow, "infoHigh": InfoHigh] as [String : Any]
        let url = "addUserinfo"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    /// 修改用户资料
//    updateUserInfo
//    JSONObject :
//    userId:String//用户id
//    userName:String
//    sex:int
//    birth:String
//    Height:int
//    Weight:int
//    info_low:int
//    info_high:int
    static func modifyUser(_ userId: String, userName: String,sex: String,birth: String,height: Int, weight: Int, infoLow:Int, InfoHigh: Int, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["userId":userId, "userName": userName, "sex": sex, "birth": birth, "height": height, "weight": weight, "info_low": infoLow, "info_high": InfoHigh] as [String : Any]
        let url = "updateUserInfo"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    /// 获取单个用户资料
//    getUserByUserId
//    JSONObject :
//    userId:String//用户id
//
//    返回：//TODO
    static func getSingleUser(_ userId: String, success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["userId" : userId]
        let url = "getUserByUserId"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    
    /// 获取所有用户资料
//    getUserByManagerId
//    managerId:int
//
//    返回：//TODO
    static func getAllUser(_ success: RequestSuccessBlock?, failure: RequestFailureBlock?) {
        let params = ["managerId" : MANAGER_ID]
        let url = "getUserByManagerId"
        CYNetworkingRequest.post(url, params, { (data) in
            if success != nil {
                let isSuccess = true
                success!(isSuccess, data)
            }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    
}
