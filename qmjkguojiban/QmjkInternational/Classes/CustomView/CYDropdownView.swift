//
//  CYDropdownView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/20.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYDropdownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    typealias SelectRowAtIndex = (_ row: Int) -> ()
    var selectRowAtIndex: SelectRowAtIndex?
    
    let heightOfRow: CGFloat = 44
    var tableView: UITableView!
    
    var values: [String] = ["unknown"] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.1
        
        self.backgroundColor = UIColor.white
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self as UITableViewDataSource
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        self.addSubview(tableView)
    }
    
    // MARK: table view delegate & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "dropdownCell")
            
        }
        
        cell?.textLabel?.text = values[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 线
        let line  = UILabel(frame: CGRect(x: 0, y: heightOfRow - 0.5, width: screenW, height: 0.5))
        line.backgroundColor = rgbColor(r: 235, g: 236, b: 237, a: 0.8)
        cell?.contentView.addSubview(line)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectRowAtIndex != nil {
            selectRowAtIndex!(indexPath.row)
        }
    }
    
    
    // MARK: 布局
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = self.bounds
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
