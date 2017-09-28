//
//  CYAddInfoFourthViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddInfoFourthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var user = CYSubUserInfo()
    var isEditInfo = false    // 是否为编辑资料
    var sid: Int64?
    
    var heights: [String]?
    var height: String?
    
    /**
     100cm = 3.28083ft(英尺)
     1kg = 0.45359lb(磅)
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 身高范围
        heights = [String]()
        for i in 140...200 {
            heights?.append("\(i)")
        }
        pickerView.reloadAllComponents()
        pickerView.selectRow((heights?.count)!/2, inComponent: 0, animated: false)
        height = heights?[(heights?.count)! / 2]
        heightLabel.text = height
    }

    @IBAction func next(_ sender: Any) {
        user.height = height!
        self.performSegue(withIdentifier: "addSegue5", sender: self)
    }
    
    // MARK: picker view delegate & datasource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heights?.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return heights?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        heightLabel.text = heights?[row]
        height = heights?[row]
    }

    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue5" {
            let vc = segue.destination as! CYAddInfoFifthViewController
            vc.user = user
            vc.isEditInfo = isEditInfo
            vc.sid = sid
        }
    }
    
}
