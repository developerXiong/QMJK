//
//  CYAddInfoSixthViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAddInfoSixthViewController: UIViewController {

    @IBOutlet weak var highBtn: UIButton!
    @IBOutlet weak var highView: UIView!
    @IBOutlet weak var lowBtn: UIButton!
    @IBOutlet weak var lowView: UIView!
    
    var user = CYSubUserInfo()
    var isEditInfo = false    // 是否为编辑资料
    var sid: Int64?
    
    let highValues = ["80 mmHg", "90 mmHg", "100 mmHg", "110 mmHg"]
    let lowValues = ["50 mmHg", "60 mmHg", "70 mmHg", "80 mmHg"]
    
    var highH: CGFloat! = 0
    var lowH: CGFloat! = 0
    
    var dropdownHighView: CYDropdownView!
    var dropdownLowView: CYDropdownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        highBtn.setTitle(highValues[0], for: .normal)
        lowBtn.setTitle(lowValues[0], for: .normal)
        
        dropdownHighView = CYDropdownView(frame: CGRect(x: 38, y: highBtn.BottomY + 1 + highView.TopY, width: screenW - 38 * 2 , height: 0))
        dropdownLowView = CYDropdownView(frame: CGRect(x: 38, y: lowBtn.BottomY + 1 + lowView.TopY, width: screenW - 38 * 2, height: 0))
        view.addSubview(dropdownLowView)
        view.addSubview(dropdownHighView)
        dropdownHighView.isHidden = true
        dropdownLowView.isHidden = true
        
        highH = CGFloat(highValues.count * 44)
        lowH = CGFloat(lowValues.count * 44)
    }

    /// 点击高压
    @IBAction func highAction(_ sender: UIButton) {
        handleClick(self.dropdownHighView, isHigh: true)
        hidden(dropdownLowView)
    }
    
    /// 点击低压
    @IBAction func lowAction(_ sender: UIButton) {
        handleClick(self.dropdownLowView, isHigh: false)
        hidden(dropdownHighView)
    }
    
    func handleClick(_ view: CYDropdownView!, isHigh: Bool) {
        view.isHidden = false
        UIView.animate(withDuration: 0.5) {
            view.frame.size.height = isHigh ? self.highH:self.lowH
            view.values = isHigh ? self.highValues:self.lowValues
            view.selectRowAtIndex = { row in
                print_debug("点击第\(row)个")
                isHigh ? self.highBtn.setTitle(self.highValues[row], for: .normal) : self.lowBtn.setTitle(self.lowValues[row], for: .normal)
                self.hidden(view)
            }
        }
    }
    
    func hidden(_ view: CYDropdownView!) {
        view.isHidden = true
        view.frame.size.height = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidden(dropdownLowView)
        hidden(dropdownHighView)
    }
    
    /// 添加子用户
    @IBAction func finishingAction(_ sender: Any) {
        let low = lowBtn.currentTitle!
        let high = highBtn.currentTitle!
        user.lowBP = low.replacingOccurrences(of: " mmHg", with: "")
        user.highBP = high.replacingOccurrences(of: " mmHg", with: "")
        user.creatTime = Date()
        let db = CYDatabaseManager.shared
        
        if isEditInfo {
            if sid == nil {
                CYAlertView.showText("Update sub user failed", on: view, duration: 1.5, position: .center)
            }
            user.sid = sid!
            let isSuccess = db.updateData(user: user)
            if !isSuccess {
                CYAlertView.showText("Update sub user failed", on: view, duration: 1.5, position: .center)
                return
            } else {
                print_debug(user)
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let isSuccess = db.insertData(subUser: user)
            if !isSuccess {
                CYAlertView.showText("Add sub user failure", on: view, duration: 1.5, position: .center)
                return
            } else {
                print_debug(user)
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
}
