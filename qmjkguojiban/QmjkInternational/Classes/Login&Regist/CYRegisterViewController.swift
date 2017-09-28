//
//  CYRegisterViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYRegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var isAgree: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func register(_ sender: Any) {
        let email = emailTF.text!
        let password = passwordTF.text!
        let confirmPassword = confirmPasswordTF.text!
        if email.isEmpty {
            CYAlertView.showText("Email cannot be empty", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        if password.isEmpty {
            CYAlertView.showText("Password cannot be empty", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        if confirmPassword.isEmpty {
            CYAlertView.showText("Confirm password cannot be empty", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        if password != confirmPassword {
            CYAlertView.showText("Password input inconsistent", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        
        /// request server
//        CYRequestHandler.regist(email, password, success: { (isSuccess, data) in
//            if isSuccess {
//                CYAlertView.showText("Regist success", on: self.view, duration: 1.5, position: .center, style: nil)
//                self.navigationController?.popViewController(animated: true)
//            } else {
//                CYAlertView.showText("User already exists", on: self.view, duration: 1.5, position: .center, style: nil)
//            }
//        }) { (error) in
//            CYAlertView.showText("Regist failure", on: self.view, duration: 1.5, position: .center, style: nil)
//        }
        
        let db = CYDatabaseManager.shared
        let isSuccess = db.insertData(_password: password, _email: email, _isUpload: false)
        
        registQmjk { (_isSuccess, errMsg) in
            if isSuccess && _isSuccess {
                CYAlertView.showText("Regist success", on: self.view, duration: 1.5, position: .center, style: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                CYAlertView.showText("Regist failure", on: self.view, duration: 1.5, position: .center, style: nil)
            }
        }
        
    }
    
    /// 注册全民健康sdk账号
    private func registQmjk(_ isSuccess:((Bool, String)->())?) {
        var params = [String: Any]()
        params["userAccount"] = emailTF.text
        params["sex"] = "1"
        params["birth"] = "1990-01-01"
        params["height"] = "178"
        params["weight"] = "66"
        params["infoLow"] = ""
        params["infoHigh"] = ""
        params["infoBPSituation"] = "4"
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
                isSuccess!(false, error.debugDescription)
            }
            debugPrint("注册全民健康账号失败")
        }
    }
    
    
    @IBAction func protocolAction(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print_debug("点击屏幕")
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        confirmPasswordTF.resignFirstResponder()
    }
    
    // MARK: text field delegate
    
    /// 点击TF的完成
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(emailTF) {
            emailTF.resignFirstResponder()
        } else if textField.isEqual(passwordTF) {
            passwordTF.resignFirstResponder()
        } else if textField.isEqual(confirmPasswordTF) {
            confirmPasswordTF.resignFirstResponder()
        }
        return true
    }

}
