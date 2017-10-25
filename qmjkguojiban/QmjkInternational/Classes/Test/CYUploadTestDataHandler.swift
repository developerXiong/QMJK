//
//  CYUploadTestDataHandler.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYUploadTestDataHandler: NSObject {

    /// 上传体检记录
    static func uploadTest(_ history: CYHistory, isSuccess: ((Bool, String)->())?) {
        self.uploadServerTest(history, isSuccess: { (isServerSuccess, errMsg) in
            if isSuccess != nil {
                isSuccess!(isServerSuccess, errMsg)
            }
        })
    }
    
    /// 上传体检记录到本地
//    static func uploadLocationTest(_ history: CYHistory, isSuccess: ((Bool)->())?) {
//        let db = CYDatabaseManager.shared
//        let isLocationSuccess = db.insert(_history: history)
//
//        if isSuccess != nil {
//            isSuccess!(isLocationSuccess)
//        }
//    }
    
    /// 上传体检记录到服务器
    static func uploadServerTest(_ history: CYHistory, isSuccess: ((Bool, String)->())?) {
        CYRequestHandler.uploadTestRecord(history.userId!, history.monitorRate!, history.monitorOxygen!, history.monitorLow!, history.monitorHigh!, history.monitorPI!, history.monitorBreath!, "unknown", success: { (isServerSuccess, data) in
            if isSuccess != nil {
                isSuccess!(isServerSuccess, String(describing: data!["errorMsg"]))
            }
        }) { (error) in
            if isSuccess != nil {
                isSuccess!(false, "Request failure")
            }
        }
    }
    
}
