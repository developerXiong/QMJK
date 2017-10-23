//
//  CYPersonEditingTableViewCell.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYPersonEditingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var section: Int!
    var editBlock: EditBlock?
    var removeBlock: RemoveBlock?
    
    typealias EditBlock = (Int) -> ()
    typealias RemoveBlock = (Int) -> ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    /// 设置cell
    func setCell(_ user: CYUser) {
        
        nicknameLabel.text = user.userName
        dateLabel.text = user.createTime
    }

    /// 编辑
    @IBAction func edit(_ sender: UIButton) {
        if self.editBlock != nil {
            self.editBlock!(section)
        }
    }
    
    /// 删除
    @IBAction func remove(_ sender: UIButton) {
        if removeBlock != nil {
            removeBlock!(section)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
