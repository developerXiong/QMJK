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
    
    var user = CYUser()
    var isEditInfo = false    // 是否为编辑资料
    var userId: String?

    let highValues = ["100~109 mmHg", "110~119 mmHg", "120~129 mmHg", "130~139 mmHg", "140~149 mmHg", "150~159 mmHg"]
    let highBPs = ["105", "115", "125", "135", "145", "155"]
    let lowValues = ["50~59 mmHg", "60~69 mmHg", "70~79 mmHg", "80~89 mmHg", "90~99 mmHg", "100~109"]
    let lowBPs = ["55", "65", "75", "85", "95", "105"]
    
    var highH: CGFloat! = 0
    var lowH: CGFloat! = 0
    var highIndex: Int = 0
    var lowIndex: Int = 0
    
    var dropdownHighView: CYDropdownView!
    var dropdownLowView: CYDropdownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        highIndex = 2
        lowIndex = 2
        highBtn.setTitle(highValues[highIndex], for: .normal)
        lowBtn.setTitle(lowValues[lowIndex], for: .normal)
        
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
                debugPrint("点击第\(row)个")
                if isHigh {
                    self.highIndex = row
                    self.highBtn.setTitle(self.highValues[row], for: .normal)
                } else {
                    self.lowIndex = row
                    self.lowBtn.setTitle(self.lowValues[row], for: .normal)
                }
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
        
        user.infoLow = lowBPs[lowIndex]
        user.infoHigh = highBPs[highIndex]
        let dfm = DateFormatter()
        dfm.dateFormat = "dd/MM/yyyy HH:mm"
        user.createTime = dfm.string(from: Date())
        
        if isEditInfo {
            /// 更新用户
            if userId == nil {
                CYAlertView.showText("Update sub user failed", on: view, duration: 1.5, position: .center)
            }
            user.userId = userId!
            
            CYAddUpdateSubserHandler.updateUser(user, isSuccess: { (isSuccess, errMsg) in
                if isSuccess {
                    CYAlertView.showText("Update sub user success", on: self.view, duration: 1.5, position: .center)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    CYAlertView.showText("Update sub user failure," + errMsg, on: self.view, duration: 1.5, position: .center)
                }
            })
            
        } else {
            /// 添加用户
            CYAddUpdateSubserHandler.addUser(user, isSuccess: { (isSuccess, errMsg) in
                if isSuccess {
                    CYAlertView.showText("Add sub user success", on: self.view, duration: 1.5, position: .center)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    CYAlertView.showText("Add sub user failure," + errMsg, on: self.view, duration: 1.5, position: .center)
                }
            })
        }
    }
    
}
