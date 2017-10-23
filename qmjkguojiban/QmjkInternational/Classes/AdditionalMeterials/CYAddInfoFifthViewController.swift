//
//  CYAddInfoFifthViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddInfoFifthViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var user = CYUser()
    var isEditInfo = false    // 是否为编辑资料
    var userId: String?

    var weights: [String]?
    var weight: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 身高范围
        weights = [String]()
        for i in 35...100 {
            weights?.append("\(i)")
        }
        pickerView.reloadAllComponents()
        pickerView.selectRow((weights?.count)!/2, inComponent: 0, animated: false)
        weight = weights?[(weights?.count)! / 2]
        weightLabel.text = weight
    }

    @IBAction func next(_ sender: Any) {
        user.weight = weight!
        self.performSegue(withIdentifier: "addSegue6", sender: self)
    }
    
    // MARK: picker view delegate & datasource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weights?.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weights?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weightLabel.text = weights?[row]
        weight = weights?[row]
    }
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue6" {
            let vc = segue.destination as! CYAddInfoSixthViewController
            vc.user = user
            vc.isEditInfo = isEditInfo
            vc.userId = userId
        }
    }
    
}
