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
        
        /// 登录qmjk云平台
        CYLoginRegistHandler.loginQmjk(email) { (isQmjkSuccess, errMsg) in
            if isQmjkSuccess {
                
                /// 服务器登录
                CYLoginRegistHandler.loginServer(email, password, is_success: { (isServerSuccess, serverUser, errMsg) in
                    if isServerSuccess {
                        /// 持久化userId
                        store(serverUser?.managerId, key: kManagerId)
                        /// 持久化user
                        self.storeUser(serverUser!)
                        /// 跳转主页面
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        
                    } else {
                        CYAlertView.showText("Login failed," + errMsg, on: self.view, duration: 1.5, position: .center, style: nil)
                    }
                })
            } else {
                CYAlertView.showText("Login failed, user is not exists", on: self.view, duration: 1.5, position: .center, style: nil)
            }
        }
        
    }
    
    
    /// 将登陆数据存储到plist中
    private func storeUser(_ user: CYManager!) {
        let dict = NSMutableDictionary()
        dict["managerId"] = user.managerId!
        dict["email"] = user.email!
        dict["password"] = user.password!
        
        /// 读取plist文件
        var datas = NSMutableArray(contentsOfFile: loginInfoPath)
        
        if datas == nil {
            datas = NSMutableArray()
        } else if (datas?.count)! > 2 {
            if !(datas?.contains(dict))! {
                datas?.removeLastObject()
            }
        } else {
        }
        datas?.insert(dict, at: 0)
        datas?.write(toFile: loginInfoPath, atomically: true)
    }
    

    /// 点击下拉框的内容
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
                debugPrint("点击第\(row)个")
                let dict = self.datas![row] as? [String : Any]
                self.emailTF.text = dict!["email"] as? String
                self.passwordTF.text = dict!["password"] as? String
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
        debugPrint("点击屏幕")
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
