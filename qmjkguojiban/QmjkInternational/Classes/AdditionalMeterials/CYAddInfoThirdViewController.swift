//
//  CYAddInfoThirdViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddInfoThirdViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var user = CYSubUserInfo()
    var isEditInfo = false    // 是否为编辑资料
    var sid: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showDate(Date())
    }

    @IBAction func next(_ sender: Any) {
        let dfm = DateFormatter()
        dfm.dateFormat = "yyyy-MM-dd"
        let year = dfm.string(from: datePicker.date)
        user.birth = year
        self.performSegue(withIdentifier: "addSegue4", sender: self)
    }
    
    @IBAction func slidePicker(_ sender: UIDatePicker) {
        let date = sender.date
        showDate(date)
    }
    
    func showDate(_ date: Date) {
        let dfm = DateFormatter()
        dfm.dateFormat = "dd/MM/yyyy"
        let dateStr = dfm.string(from: date)
        dateLabel.text = dateStr
    }
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue4" {
            let vc = segue.destination as! CYAddInfoFourthViewController
            vc.user = user
            vc.isEditInfo = isEditInfo
            vc.sid = sid
        }
    }
    
}
