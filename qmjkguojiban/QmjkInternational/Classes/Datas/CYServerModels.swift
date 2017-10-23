//
//  CYServerModels.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/23.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

/// 走服务器模型

import UIKit
import HandyJSON

/// 管理者模型
struct CYManager: HandyJSON {

    var managerId: String?
    var email: String?
    var password: String?
    
}

/// 用户模型
struct CYUser: HandyJSON {
    var userId: String?
    var age: String?
    var birth: String?
    var createTime: String?
    var height: String?
    var id: String?
    var infoHigh: String?
    var infoLow: String?
    var lastUpdateInfoTime: String?
    var managerId: String?
    var sex: String?
    var userName: String?
    var weight: String?
    
    /// 字典数组转模型数组
    static func objectWithKeyValues(_ jsonArray: [[String : Any]]) -> [CYUser?]? {
        if var result = [CYUser].deserialize(from: jsonArray) {
            var r: CYUser?
            for i in 0..<result.count {
                r = result[i]
                guard let c = r?.createTime else {
                    break
                }
                let index = c.index(c.endIndex, offsetBy: -3)
                r?.createTime = String(c[..<index])
                result[i] = r
            }
            return result
        }
        return nil
    }
}

/// 历史记录模型 
struct CYHistory: HandyJSON {
    var beginTime: String?
    var createTime: String?
    var deviceId: String?
    var endTime: String?
    var id: String?
    var monitorAWX: String?
    var monitorBreath: Int?
    var monitorHigh: Int?
    var monitorLow: Int?
    var monitorOxygen: Int?
    var monitorPI: Int?
    var monitorPWTT: String?
    var monitorRate: Int?
    var monitorWaveWidth: String?
    var pageNo: String?
    var searchType: String?
    var userId: String?
    
    /// 字典数组转模型数组 
    static func objectWithKeyValues(_ jsonArray: [[String : Any]]) -> [CYHistory?]? {
        if let result = [CYHistory].deserialize(from: jsonArray) {
            return result
        }
        return nil
    }
}
