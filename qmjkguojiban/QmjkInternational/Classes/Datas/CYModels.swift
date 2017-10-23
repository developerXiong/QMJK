//
//  CYModels.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/21.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

/// 走本地数据库的模型  ---- 废弃了 

import UIKit

// MARK: 用户模型
//class CYUserInfo: NSObject {
//
//    var id: Int64?
//    var email: String?
//    var password: String?
//    var isUpload: Bool = false
//}
//
//// MARK: 子用户模型
//class CYSubUserInfo: NSObject {
//    
//    var sid: Int64?
//    var name: String?
//    var creatTimeStr: String? {
//        let dfm = DateFormatter()
//        dfm.dateFormat = "dd/MM/yyyy HH:mm"
//        return dfm.string(from: creatTime!)
//    }
//    var creatTime: Date?
//    var sex: Bool?       // true: 男 false: 女
//    var birth: String?   // "yyyy-MM-dd"
//    var realAge: String? {
//        set {
//            self.realAge = newValue
//        }
//        get {
//            guard let birth = birth else {
//                return nil
//            }
//            let dfm = DateFormatter()
//            dfm.dateFormat = "yyyy"
//            let year = birth.split(separator: "-")[0]
//            let currentYear = dfm.string(from: Date())
//            let age = Int(currentYear)! - Int(year)!
//            return "\(age)"
//        }
//    }
//    var height: String?
//    var weight: String?
//    var highBP: String?
//    var lowBP: String?
//    var user_id: Int64?
//    var isUpload: Bool = false
//    
//    convenience init(age: String, birth:String, createTime: String, height: String, weight: String, userId: String, userName: String, sex: Int, managerId: String, infoHigh: String, infoLow: String) {
//        self.init()
//        self.realAge = age
//        self.birth = birth
//        let dfm = DateFormatter()
//        dfm.dateFormat = "dd/MM/yyyy HH:mm"
//        self.creatTime = dfm.date(from: createTime)
//        self.height = height
//        self.weight = weight
////        self.sid = userId
//    }
//    
//}
//
//// MARK: 历史记录模型
//class CYHistory: NSObject {
//    
//    var hid: Int64?
//    var rate: Int?
//    var oxygen: Int?
//    var breath: Int?
//    var high: Int?
//    var low: Int?
//    var PI: Int?
//    var createTime: Date?
//    var creatTimeStr: String? {
//        let dfm = DateFormatter()
//        dfm.dateFormat = "dd/MM/yyyy HH:mm"
//        return dfm.string(from: createTime!)
//    }
//    var sid_id: Int64?
//    var isUpload: Bool = false
//}

