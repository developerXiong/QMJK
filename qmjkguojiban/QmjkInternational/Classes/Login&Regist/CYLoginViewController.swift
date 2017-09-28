//
//  CYLoginViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailView: UIView!
    
    var datas: NSArray? // [["userId":""],["email":""],["password":""]]
    
    var dropdownView: CYDropdownView?
    var dropdownViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setNavbarHidden(vc: self, hidden: true)
        setStatusBar(to: .default)
        
        // 获取持久化的账号信息
        datas = NSMutableArray(contentsOfFile: loginInfoPath)
        
        // 写账号到输入框
        if (datas != nil) {
//            var dict = [String : String]()
            let dict = datas![0] as! NSMutableDictionary
            let email = dict["email"] as! String
            let password = dict["password"] as! String
            emailTF.text = email
            passwordTF.text = password
            addSubviews()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavbarHidden(vc: self, hidden: false)
    }
    
    private func addSubviews() {
        dropdownView = CYDropdownView(frame: CGRect(x: emailView.LeftX, y: emailView.BottomY - 44 + 1, width: screenW - 16 * 2, height: 0))
        view.addSubview(dropdownView!);
        dropdownView?.isHidden = true
        
        if (datas != nil) {
            dropdownViewHeight = CGFloat((datas?.count)! * 44)
        }
    }

    // MARK: 点击事件
    
    /// 点击登录
    @IBAction func login(_ sender: UIButton) {
        
        let email = emailTF.text!
        let password = passwordTF.text!
        if email.isEmpty {
            CYAlertView.showText("Email cannot be empty", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        if password.isEmpty {
            CYAlertView.showText("Password cannot be empty", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        
        /// request server
//        CYRequestHandler.login(email, password: password, success: { (isSuccess, data) in
//            if isSuccess {
//                /// 登录成功
//                guard let data = data else { return }
//                var user = CYUserInfo()
//                user.email = email
//                user.password = password
//                user.id = data["userManager"] as? Int64
//                print_debug("Login success")
//                self.loginQmjk(email)
//                /// 持久化userId
//                store(user.id, key: kUserId)
//                self.storeUser(user)
//                self.performSegue(withIdentifier: "loginSegue", sender: self)
//            } else {
//                /// 登录失败
//                CYAlertView.showText("User doesn't exist", on: self.view, duration: 1.5, position: .center, style: nil)
//            }
//        }) { (error) in
//            CYAlertView.showText("Login failed, please check your email and password", on: self.view, duration: 1.5, position: .center, style: nil)
//        }
        
        let db = CYDatabaseManager.shared
        let user = db.readAData(_email: email, _password: password)
        
        guard let _user = user else {
            CYAlertView.showText("User doesn't exist", on: self.view, duration: 1.5, position: .center, style: nil)
            return
        }
        
        print_debug("Login success")
        loginQmjk(email)
        /// 持久化userId
        store(_user.id, key: kUserId)
        storeUser(_user)
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    /// 将登陆数据存储到plist中
    private func storeUser(_ user: CYUserInfo!) {
        let dict = NSMutableDictionary()
        dict["userId"] = user.id!
        dict["email"] = user.email!
        dict["password"] = user.password!
        
        /// 读取plist文件
        var datas = NSMutableArray(contentsOfFile: loginInfoPath)
        
        if datas == nil {
            datas = NSMutableArray()
            datas?.insert(dict, at: 0)
        } else if (datas?.count)! > 2 {
            if !(datas?.contains(dict))! {
                datas?.removeLastObject()
                datas?.insert(dict, at: 0)
            }
        }
        datas?.write(toFile: loginInfoPath, atomically: true)
    }
    
    func loginQmjk(_ account: String) {
        QmjkRegisterHttpHandler.login(withAccount: account, success: { (response) in
            let resp = response as! [AnyHashable : Any]
            let errorMsg = resp["errorMsg"] as! String
            if errorMsg.isEmpty {
                print_debug("登录qmjk成功:\(response!)")
            } else {
                print_debug("登录qmjk失败: \(errorMsg)")
            }
        }) { (error) in
            print_debug("登录qmjk错误: \(error!)")
        }
    }

    /// 点击下拉
    @IBAction func more(_ sender: Any) {
        if datas == nil {
            return
        }
        dropdownView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.dropdownView?.frame.size.height = self.dropdownViewHeight
            var emails = [String]()
            for dict in self.datas! {
                let d = dict as! NSMutableDictionary
                emails.append(d["email"]! as! String)
            }
            self.dropdownView?.values = emails
            self.dropdownView?.selectRowAtIndex = { row in
                print_debug("点击第\(row)个")
                self.hiddenDropdownView()
            }
        }
    }
    
    /// 隐藏下拉框
    private func hiddenDropdownView() {
        self.dropdownView?.isHidden = true
        self.dropdownView?.frame.size.height = 0.0
    }
    
    /// 点击显示/隐藏密码
    @IBAction func show(_ sender: UIButton) {
        passwordTF.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print_debug("点击屏幕")
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        hiddenDropdownView()
    }
    
    // MARK: text field delegate
    
    /// 点击TF的完成
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(emailTF) {
            emailTF.resignFirstResponder()
        } else if textField.isEqual(passwordTF) {
            passwordTF.resignFirstResponder()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "loginSegue" {
//            let vc = segue.destination as! CYMainNavigationController
//            for VC in vc.childViewControllers {
//                if VC.isKind(of: CYPersonnelListViewController.self) {
//                    let mainVc = VC as! CYPersonnelListViewController
//                    mainVc.userId = user?.id
//                }
//            }
//        }
    }
 

}
