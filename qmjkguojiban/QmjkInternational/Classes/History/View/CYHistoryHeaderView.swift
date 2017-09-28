//
//  CYHistoryHeaderView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryHeaderView: UIView {

    
    static func loadView() -> CYHistoryHeaderView? {
        return Bundle.main.loadNibNamed("CYHistoryHeaderView", owner: nil, options: nil)?.last as? CYHistoryHeaderView
    }
    

}
