//
//  CYHistoryFooterView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryFooterView: UIView {
    @IBOutlet weak var shadowView: UIView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        let view = CYHistoryFooterView.loadView()
//        view?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//        view?.shadowView.layer.shadowColor = UIColor.black.cgColor
//        self.addSubview(view!)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
//        
//        let view = CYHistoryFooterView.loadView()
//        view?.frame = self.bounds
//        view?.shadowView.layer.shadowColor = UIColor.black.cgColor
//        self.addSubview(view!)
//    }

    static func loadView() -> CYHistoryFooterView? {
        return Bundle.main.loadNibNamed("CYHistoryFooterView", owner: nil, options: nil)?.last as? CYHistoryFooterView
    }

}
