//
//  CYAddInfoFirstViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddInfoFirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nicknameTF: UITextField!
    
    var user = CYUser()
    var isEditInfo = false    // 是否为编辑资料
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /// 下一步
    @IBAction func next(_ sender: UIButton) {
        let nickname = nicknameTF.text
        if (nickname?.isEmpty)! {
            CYAlertView.showText("Nick name cannot be empty", on: view, duration: 1.5, position: .center)
            return
        }
        user.userName = nickname
        self.performSegue(withIdentifier: "addSegue2", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nicknameTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknameTF.resignFirstResponder()
        return true
    }

    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue2" {
            let vc = segue.destination as! CYAddInfoSecondViewController
            vc.user = user
            vc.isEditInfo = isEditInfo
            vc.userId = userId
        }
    }
    
}
