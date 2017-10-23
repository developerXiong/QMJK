//
//  CYNetworkingRequest.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/26.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit
import Alamofire

class CYNetworkingRequest: NSObject {

    static let url = "http://192.168.0.150:8085/qmjk-internation/"
    
    typealias RequestSuccessBlock = ([String : Any]?) -> ()
    typealias RequestFailureBlock = (String) -> ()
    
    /// post请求
    static func post(_ url: String, _ paramters: [String: Any]?, _ success: RequestSuccessBlock?, _ failure: RequestFailureBlock?) {
        let requestURL = self.url + url + ".do"
        Alamofire.request(requestURL, method: .post, parameters: paramters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.isSuccess {
                if (success != nil) {
                    debugPrint(response.result.value ?? "请求\(requestURL)没有数据返回")
                    let result = response.result.value as? [String : Any]
                    success!(result)
                }
            } else {
                if failure != nil {
                    debugPrint(response.result.error ?? "error nil")
                    let error = "Request" + "\(requestURL)" + " failed. Your parameters like this: " + "\(String(describing: paramters))"
                    failure!(error)
                }
            }
        }
    }
    
    /// get请求
    static func get(_ url: String, _ paramters: [String: Any]?, _ success: RequestSuccessBlock?, _ failure: RequestFailureBlock?) {
        let requestURL = self.url + url + ".do"
        Alamofire.request(requestURL, method: .get, parameters: paramters).responseJSON { response in
            debugPrint("Response String: \(response.result.value ?? "asd")")
            if response.result.isSuccess {
                if (success != nil) {
                    debugPrint(response.result.value ?? "请求\(requestURL)没有数据返回")
                    let result = response.result.value as? [String : Any]
                    success!(result)
                }
            } else {
                if failure != nil {
                    let error = "Request" + "\(requestURL)" + " failed. Your parameters like this: " + "\(String(describing: paramters))"
                    failure!(error)
                }
            }
        }
    }
    
    /// 监测网络状态
    static func monitorNetworking(_ status: ((Bool) -> ())?) {
        let manager = NetworkReachabilityManager()
        guard let status = status else { return }
        manager?.listener = { state in
            switch state {
            case .notReachable:
                debugPrint("没网络")
                status(false)
            case .unknown:
                debugPrint("未知网络")
                status(false)
            case .reachable(.ethernetOrWiFi):
                debugPrint("WIFI连接")
                status(true)
            case .reachable(.wwan):
                debugPrint("局域网连接")
                status(true)
            }
        }
        manager?.startListening()
    }
    
    
    /// JSONString转换为字典
    static func getDictionaryFromJSONString(jsonString: String?) -> NSDictionary? {
        guard let jsonString = jsonString else {
            return nil
        }
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as? NSDictionary
        }
        return NSDictionary()
    }
    
}
