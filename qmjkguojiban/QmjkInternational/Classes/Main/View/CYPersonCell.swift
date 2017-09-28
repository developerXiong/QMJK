//
//  CYPersonCell.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYPersonCell: UITableViewCell {
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var section: Int!
    
    typealias StartTestBlock = (Int) -> Void
    typealias HistoryBlock = (Int) -> Void
    
    var startBlock: StartTestBlock?
    var historyBlock: HistoryBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        historyBtn.layer.borderColor = blueColor.cgColor
        testBtn.layer.borderColor = blueColor.cgColor
        
    }
    
    /// 设置cell
    func setCell(_ user: CYSubUserInfo) {
        
        nicknameLabel.text = user.name
        dateLabel.text = user.creatTimeStr
    }
    
    /// 开始测量
    @IBAction func startTest(_ sender: UIButton) {
        if startBlock != nil {
            self.startBlock!(self.section)
        }
    }
    
    /// 历史记录
    @IBAction func history(_ sender: UIButton) {
        if self.historyBlock != nil {
            self.historyBlock!(self.section)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
