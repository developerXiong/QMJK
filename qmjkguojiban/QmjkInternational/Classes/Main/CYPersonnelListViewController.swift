//
//  CYPersonnelListViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYPersonnelListViewController: UITableViewController {
    
    typealias ReloadDataBlock = () -> ()

    var datas: [CYUser]?
    
    var section: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusBar(to: .lightContent)
        
        self.tableView.register(CYPersonCell.self, forCellReuseIdentifier: "PersonCell")
        self.tableView.register(CYAdditionButtonCell.self, forCellReuseIdentifier: "AddCell")
        
    }
    
    /// 获取数据
    func getData() {
        datas = [CYUser]()
        CYPersonnelDataHandler.getSubUsers { (users, errMsg) in
            guard let users = users else { return }
            self.datas = users
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        setNavbarTintColor(vc: self, isNormal: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavbarTintColor(vc: self, isNormal: true)
    }
    
    // MARK: Action
    
    /// 退出登录
    @IBAction func loginout(_ sender: UIBarButtonItem) {
        CYAlertView.showSystemAlert(on: self, title: "tips", message: "Logout?", sureHandler: { (_) in
            store(nil, key: kManagerId)
            self.performSegue(withIdentifier: "backToLogin", sender: self)
        }, cancelHandler: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (datas?.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == datas?.count {
            /// 添加信息的cell
            let cell = Bundle.main.loadNibNamed("CYAdditionButtonCell", owner: nil, options: nil)?.last as? CYAdditionButtonCell
            cell?.section = indexPath.section
            cell?.addAccount = { section in
                /// 添加账号
                self.performSegue(withIdentifier: "addSegue1", sender: self)
            }
            
            return cell!
        } else {
            /// 主要的cell
            let cell = Bundle.main.loadNibNamed("CYPersonCell", owner: nil, options: nil)?.last as? CYPersonCell
            self.section = indexPath.section
            cell?.section = indexPath.section
            cell?.setCell((datas?[indexPath.section])!)
            cell?.startBlock = { section in
                /// 开始测量
                if isCanTest {
                    self.performSegue(withIdentifier: "toTestSegue", sender: self)
                }
            }
            cell?.historyBlock = { section in
                /// 历史记录
                self.performSegue(withIdentifier: "historySegue", sender: self)
            }
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == datas?.count {
            return 0.000001
        }
        return 12
    }
    
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue1" {
            let vc = segue.destination as! CYAddInfoFirstViewController
            vc.isEditInfo = false
        }
        if segue.identifier == "toDetailSegue" {
            let vc = segue.destination as! CYPersonnelListEditingViewController
            vc.datas = self.datas
            vc.userId = self.datas![section].userId
        }
        if segue.identifier == "historySegue" {
            let vc = segue.destination as! CYHistoryListViewController
            vc.userId = self.datas![section].userId
        }
        if segue.identifier == "toTestSegue" {
            let vc = segue.destination as! CYTestViewController
            vc.userId = self.datas![section].userId
            vc.subUser = self.datas![section]
        }
    }

}
