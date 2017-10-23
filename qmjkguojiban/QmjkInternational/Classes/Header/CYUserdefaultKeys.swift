//
//  CYUserdefaultKeys.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/25.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit


let userDefaluts = UserDefaults.standard

let qmjkAppId = "558640269"
let qmjkAppKey = "yk876lxuj0npnrti7j8y"

/// 持久化登陆信息的plist文件路径
let loginInfoPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/loginInfo.plist"
//let loginInfoPath = NSHomeDirectory() + "Documents/loginInfo.plist"

func store(_ value: Any?, key: String) {
    userDefaluts.set(value, forKey: key)
    userDefaluts.synchronize()
}


let kManagerId = "kQmjkInternationalManagerId"
var MANAGER_ID: String {
    return userDefaluts.string(forKey: kManagerId) ?? ""
}

