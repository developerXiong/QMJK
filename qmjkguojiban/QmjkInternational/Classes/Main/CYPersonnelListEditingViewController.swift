//
//  CYPersonnelListEditingViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYPersonnelListEditingViewController: UITableViewController {

    var datas: [CYUser]?
    var section: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "图层-84"), style: .plain, target: self, action: #selector(clickRightBarButtonItem))
        self.navigationItem.leftBarButtonItem = nil
        
        self.tableView.register(CYPersonEditingTableViewCell.self, forCellReuseIdentifier: "EditCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController as! CYMainNavigationController
        nav.isCanUseGresture = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let nav = self.navigationController as! CYMainNavigationController
        nav.isCanUseGresture = true
    }

    /// 编辑完成
    @objc func clickRightBarButtonItem() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (datas?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CYPersonEditingTableViewCell", owner: nil, options: nil)?.last as? CYPersonEditingTableViewCell
        
        cell?.section = indexPath.section
        cell?.setCell((datas?[indexPath.section])!)
        cell?.editBlock = { section in
            self.section = section
            /// 点击编辑
            self.performSegue(withIdentifier: "editToAddSegue", sender: self)
        }
        
        cell?.removeBlock = { section in
            /// 点击删除
            CYAlertView.showSystemAlert(on: self, title: "tips", message: "Delete?", sureHandler: { (_) in
                CYPersonnelDataHandler.removeServerUser(self.datas![section].userId!, { (isSuccess) in
                    if isSuccess {
                        self.datas?.remove(at: section)
                        self.tableView.reloadData()
                    } else {
                        CYAlertView.showText("Delete fail", on: self.view, duration: 0.3, position: .center)
                    }
                }, { (errMsg) in
                    CYAlertView.showText("Delete fail", on: self.view, duration: 0.3, position: .center)
                })
                
            }, cancelHandler: nil)
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 9 {
            return 0.000001
        }
        return 12
    }
    
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editToAddSegue" {
            let vc = segue.destination as! CYAddInfoFirstViewController
            vc.isEditInfo = true
            vc.userId = self.datas![section].userId
        }
    }

}
