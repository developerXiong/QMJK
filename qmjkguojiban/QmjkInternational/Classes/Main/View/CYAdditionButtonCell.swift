//
//  CYAdditionButtonCell.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYAdditionButtonCell: UITableViewCell {
    
    var section: Int!
    var addAccount: AddAccountBlock?
    
    typealias AddAccountBlock = (Int) -> ()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func addAccount(_ sender: UIButton) {
        if self.addAccount != nil {
            self.addAccount!(self.section)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
