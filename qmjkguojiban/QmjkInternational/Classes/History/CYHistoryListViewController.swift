//
//  CYHistoryListViewController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryListViewController: UITableViewController {

    var userId: String?
    var datas: [CYHistory]?
    var row: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(CYHistoryListCell.self, forCellReuseIdentifier: "historyCell")
        
        self.navigationItem.backBarButtonItem?.target = self
        self.navigationItem.backBarButtonItem?.action = #selector(clickBackBarButtonItem)
        
        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavbarTintColor(vc: self, isNormal: false)
        /// 移除滑动返回功能
        let nav = self.navigationController as! CYMainNavigationController
        nav.isCanUseGresture = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// 恢复滑动返回功能
        let nav = self.navigationController as? CYMainNavigationController
        nav?.isCanUseGresture = true
    }
    
    /// 点击返回按钮回到跟页面
    @objc private func clickBackBarButtonItem() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func getData() {
        
        CYHistoryHandler.getHistory(userId!) { (historys, errMsg) in
            self.datas = historys
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (datas?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CYHistoryListCell", owner: nil, options: nil)?.last as? CYHistoryListCell

        cell?.row = indexPath.row
        cell?.setCell(with: datas![indexPath.row])

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.row = indexPath.row
        self.performSegue(withIdentifier: "historyDetailSegue", sender: self)
    }
    
    /// 传数据到下个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyDetailSegue" {
            let vc = segue.destination as! CYHistoryViewController
            vc.history = self.datas?[row]
            vc.userId = userId
        }
    }

}
