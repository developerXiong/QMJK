//
//  CYProgressView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYProgressView: UIView {

    var titleLabel: UILabel!
    var valueLabel: UILabel!
    var unitLabel:UILabel!
    
    var stateView: UILabel!
    var progressBgView: UIView!
    var progressView: UIView!
    
    var mainColor: UIColor!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        initSubviews(frame: frame)
        
    }
    
    /// 初始化所有子视图
    func initSubviews(frame: CGRect) {
        titleLabel = UILabel()
        setLabelStyle1(titleLabel)
        valueLabel = UILabel()
        setLabelStyle1(valueLabel)
        unitLabel = UILabel()
        setLabelStyle2(unitLabel)
        
        stateView = UILabel()
        setStateViewStyle(stateView)
        
        progressBgView = UIView()
        progressBgView.backgroundColor = UIColor.lightGray
        progressBgView.layer.cornerRadius = 2;
        progressView.clipsToBounds = true   // 超出的部分剪切
        
        progressView  = UIView()
        progressView.backgroundColor = mainColor
        progressView.layer.cornerRadius = 2;
        
        titleLabel.text = "Systolic blood pressure (SBP)"
        valueLabel.text = "96"
        unitLabel.text = "%"
        stateView.text = "Normal"
        
        progressBgView.addSubview(progressView)
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
        self.addSubview(unitLabel)
        self.addSubview(stateView)
        self.addSubview(progressBgView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: 设置视图效果
extension CYProgressView {
    func setLabelStyle1(_ label: UILabel) {
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
    }
    func setLabelStyle2(_ label: UILabel) {
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 10)
    }
    
    func setStateViewStyle(_ view: UILabel) {
        view.textColor = mainColor
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .center
        view.layer.cornerRadius = 10;
        view.layer.borderColor = mainColor.cgColor
        view.layer.borderWidth = 1;
    }
}

// MARK: 布局
extension CYProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = self.frame.size
        
//        titleLabel.frame = CGRect(x: 8.0, y: 8.0, width: 0.0, height: 0.0)
//        titleLabel.sizeToFit()
//        
//        let us: CGSize = getTextSize(textStr: unitLabel.text!, font: 10)
//        unitLabel.frame = CGRect(x: size.width - 8 - us.width, y: 11, width: us.width, height: us.height)
//        
//        let vs: CGSize = getTextSize(textStr: valueLabel.text!, font: 14)
//        valueLabel.frame = CGRect(x: unitLabel.LeftX - 8 - vs.width, y: 8, width: vs.width, height: vs.height)
//        
//        let ss: CGSize = getTextSize(textStr: stateView.text!, font: 12)
//        stateView.frame = CGRect(x: 0.0, y: titleLabel.BottomY+10, width: ss.width + 10, height: 20)
//        
//        progressBgView.frame = CGRect(x: 38, y: titleLabel.BottomY + 35, width: size.width - 38 * 2, height: 4)
//        
//        progressView.frame = CGRect(x: 0, y: 0, width: 10, height: 4)
        
    }
}
