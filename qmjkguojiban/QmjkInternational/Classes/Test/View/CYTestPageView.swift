//
//  CYTestPageView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/20.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYTestPageView: UIView {
    
    var image: UIImage? {
        didSet {
            let iw = (self.image?.size)!.width
            let ih = (self.image?.size)!.height
            setNeedsLayout()
            imageView.frame = CGRect(x: (screenW / 3 - iw) / 2, y: 5, width: iw, height: ih)
            imageView.image = image!
        }
    }

    var imageView: UIImageView!
    var valueLabel: UILabel!
    var unitLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        initViews(frame)
    }
    
    func initViews(_ frame: CGRect) {
        imageView = UIImageView()
        valueLabel = UILabel()
        unitLabel = UILabel()
        self.addSubview(imageView)
        self.addSubview(valueLabel)
        self.addSubview(unitLabel)
        
        setLabelStyle(valueLabel)
        setLabelStyle(unitLabel)
        
    }
    
    func setLabelStyle(_ label: UILabel) {
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        unitLabel.frame = CGRect(x: 0, y: h - 18 - 15, width: w, height: 18)
        
        valueLabel.frame = CGRect(x: 0, y: unitLabel.TopY - 18 - 5, width: w, height: 18)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
