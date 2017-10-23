//
//  CYHistoryViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userId: String?
    
    var datas: NSArray?
    var history: CYHistory?
    
    var values: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(clickRightBarbuttonItem))
        getData()
        setTitleView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /// 获取数据
    func getData() {
        datas = NSArray(contentsOfFile: Bundle.main.path(forResource: "HistoryDetail", ofType: "plist")!)
        values = [Int]()
        values?.append((history?.monitorLow)!)
        values?.append((history?.monitorHigh)!)
        values?.append((history?.monitorOxygen)!)
        values?.append((history?.monitorRate)!)
        values?.append((history?.monitorBreath)!)
        values?.append((history?.monitorPI)!)
        tableView.reloadData()
    }
    
    private func setTitleView() {
        
        
//        nicknameLabel.text = userInfo.name
//        sexLabel.text = userInfo.sex! ? "Male" : "Female"
//        ageLabel.text = userInfo.realAge
//        timeLabel.text = userInfo.creatTimeStr
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (datas?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CYHistoryCell", owner: nil, options: nil)?.last as? CYHistoryCell
        
        if datas != nil {
            let data = datas?[indexPath.row] as? Dictionary<String, Any>
            let value = values?[indexPath.row]
            cell?.row = indexPath.row
            cell?.setCellWithData(data!, value: value!)
        }
        
        return cell!
    }
    
    /// 头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: CYHistoryHeaderView = CYHistoryHeaderView.loadView()!
        view.frame = CGRect(x: 0, y: 0, width: screenW, height: 75)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    /// 脚视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: CYHistoryFooterView = CYHistoryFooterView.loadView()!
        view.frame = CGRect(x: 0, y: 0, width: screenW, height: 220)
        view.shadowView.layer.shadowColor = UIColor.black.cgColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 220
    }

    
}
