//
//  CYAddInfoSecondViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddInfoSecondViewController: UIViewController {

    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    
    var user = CYUser()
    var isEditInfo = false    // 是否为编辑资料
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    /// 男
    @IBAction func maleAction(_ sender: UIButton) {
        btnState(sender, label: maleLabel, isSelected: true)
        btnState(femaleBtn, label: femaleLabel, isSelected: false)
    }
    
    /// 女
    @IBAction func femaleAction(_ sender: UIButton) {
        btnState(sender, label: femaleLabel, isSelected: true)
        btnState(maleBtn, label: maleLabel, isSelected: false)
    }
    
    func btnState(_ btn: UIButton, label: UILabel, isSelected: Bool) {
        btn.isSelected = isSelected
        label.textColor = isSelected ? UIColor.black : UIColor.lightGray
    }

    /// 下一步
    @IBAction func next(_ sender: Any) {
        user.sex = maleBtn.isSelected ? "1" : "2"
        self.performSegue(withIdentifier: "addSegue3", sender: self)
    }
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue3" {
            let vc = segue.destination as! CYAddInfoThirdViewController
            vc.user = user
            vc.isEditInfo = isEditInfo
            vc.userId = userId
        }
    }
    
}
