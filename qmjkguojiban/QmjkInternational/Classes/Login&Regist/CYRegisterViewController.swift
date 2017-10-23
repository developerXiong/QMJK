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
        
        /// 注册全民健康云平台
        CYLoginRegistHandler.registQmjk(email, isSuccess: { (isCloudSuccess, errMsg) in
            if isCloudSuccess {
                /// 先走服务器
                CYLoginRegistHandler.registServer(email, password, is_success: { (isServerSuccess, errMsg) in
                    if isServerSuccess {
                        CYAlertView.showText("Regist success", on: self.view, duration: 1.5, position: .center, style: nil)
                        /// 本地注册
                        CYLoginRegistHandler.registLocation(email, password, isSuccess: nil)
                    } else {
                        CYAlertView.showText("Regist failure," + errMsg, on: self.view, duration: 1.5, position: .center, style: nil)
                    }
                })
            } else {
                CYAlertView.showText("Regist failure," + errMsg, on: self.view, duration: 1.5, position: .center, style: nil)
            }
        })
    }
    
    
    @IBAction func protocolAction(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("点击屏幕")
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
