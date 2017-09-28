//
//  CYHistoryListCell.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryListCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isNewBtn: UIButton!
    @IBOutlet weak var BPLabel: UILabel!
    @IBOutlet weak var SPO2HLabel: UILabel!
    @IBOutlet weak var HRLabel: UILabel!
    @IBOutlet weak var RRLabel: UILabel!
    @IBOutlet weak var PILabel: UILabel!
    
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setCell(with history: CYHistory) {
        dateLabel.text = history.creatTimeStr
        BPLabel.text = "\(history.high!)/\(history.low!)"
        SPO2HLabel.text = "\(history.oxygen!)"
        HRLabel.text = "\(history.rate!)"
        RRLabel.text = "\(history.breath!)"
        PILabel.text = "\(history.PI!)"
        if row == 0 {
            isNewBtn.isHidden = false
        } else {
            isNewBtn.isHidden = true
        }
    }
    
    
}
