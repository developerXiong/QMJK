//
//  CYModels.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/21.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

// MARK: 用户模型
struct CYUserInfo {

    var id: Int64?
    var email: String?
    var password: String?
    var isUpload: Bool = false
}

// MARK: 子用户模型
struct CYSubUserInfo {
    
    var sid: Int64?
    var name: String?
    var creatTimeStr: String? {
        let dfm = DateFormatter()
        dfm.dateFormat = "dd/MM/yyyy HH:mm"
        return dfm.string(from: creatTime!)
    }
    var creatTime: Date?
    var sex: Bool?       // true: 男 false: 女
    var birth: String?
    var realAge: String? {
        guard let birth = birth else {
            return nil
        }
        let dfm = DateFormatter()
        dfm.dateFormat = "yyyy"
//        let yearDate = dfm.date(from: birth)
//        let year = dfm.string(from: yearDate!)
//        let year = birth[birth.startIndex..<birth.startIndex.advanced(by: 1)]
        let year = birth.substring(to: birth.startIndex.advanced(by: 4))
        let currentYear = dfm.string(from: Date())
        let age = Int(currentYear)! - Int(year)!
        return "\(age)"
    }
    var height: String?
    var weight: String?
    var highBP: String?
    var lowBP: String?
    var user_id: Int64?
    var isUpload: Bool = false
}

// MARK: 历史记录模型
struct CYHistory {
    
    var hid: Int64?
    var rate: Int?
    var oxygen: Int?
    var breath: Int?
    var high: Int?
    var low: Int?
    var PI: Int?
    var createTime: Date?
    var creatTimeStr: String? {
        let dfm = DateFormatter()
        dfm.dateFormat = "dd/MM/yyyy HH:mm"
        return dfm.string(from: createTime!)
    }
    var sid_id: Int64?
    var isUpload: Bool = false
}