//
//  CYHistoryCell.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYHistoryCell: UITableViewCell {

    enum CYIndexState {
        case normal
        case high
        case low
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var progressBgView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var scaleLabel1: UILabel!
    @IBOutlet weak var scaleLabel2: UILabel!
    @IBOutlet weak var scaleLabel3: UILabel!
    @IBOutlet weak var scaleLabel4: UILabel!
    
    
    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stateBtnXConstraint: NSLayoutConstraint!
    
    var row: Int?
    
    func setCellWithData(_ data: Dictionary<String, Any>, value: Int) {
//        let mainColor: String = data["mainColor"] as! String
        let unit: String = data["unit"] as! String
        let title: String = data["title"] as! String
        let scaleValues: [Int] = data["allValues"] as! [Int]
        
        valueLabel.text = "\(value)"
        
        /// 设置单位
        unitLabel.text = unit
        titleLabel.text = title
        
        setScaleView(scaleValues)
        setProgress(value)
    }
    
    // 设置刻度 高压: 80~180; 低压 50~110; 血氧≥94; 心率50~130; 呼吸频率8~24; PI≥0.5
    private func setScaleView(_ values: [Int]) {
        scaleLabel1.text = "\(values[0])"
        scaleLabel2.text = "\(values[1])"
        scaleLabel3.text = "\(values[2])"
        scaleLabel4.text = "\(values[3])"
        
    }
    
    /// 设置进度条相关
    private func setProgress(_ value: Int) {
        let baseLen: CGFloat = 60.0     // 进度条基本长度
        let totalLen: CGFloat = screenW - 35 * 2  // 进度条总长度
        let scaleLen = screenW - 95.0*2
        var minValue: CGFloat = 0
        var maxValue: CGFloat = 0
        var marginValue: CGFloat = 0
        var toMinValue: CGFloat = 0     // value与最小值的差距
        var scale: CGFloat = 0.0
        
        var indexState: CYIndexState = .normal // 指标数据是否正常
        switch row! {
        case 0:
            /// 低压
            minValue = 50
            maxValue = 110
            break
        case 1:
            /// 高压
            minValue = 80
            maxValue = 180
            break
        case 2:
            /// 血氧
            minValue = 94
            maxValue = 100
            break
        case 3:
            /// 心率
            minValue = 50
            maxValue = 130
            break
        case 4:
            /// 呼吸频率
            minValue = 8
            maxValue = 24
            break
        case 5:
            /// PI
            minValue = 1
            maxValue = 7
            break
        default:
            ///
            break
        }
        if CGFloat(value) <= maxValue && CGFloat(value) >= minValue {
            indexState = .normal
        } else if CGFloat(value) < minValue {
            indexState = .low
        } else {
            indexState = .high
        }
        if row == 2 {  // 血氧
            if CGFloat(value) >= 94 {
                indexState = .normal
            } else {
                indexState = .low
            }
        } else if row == 5 { // PI
            if CGFloat(value) >= 0.5 {
                indexState = .normal
            } else {
                indexState = .low
            }
        }
        /// 设置进度条长度
        marginValue = maxValue - minValue
        toMinValue = CGFloat(value) - minValue
        scale = CGFloat(toMinValue / marginValue)
        var progressWidth = baseLen + scaleLen * scale
        if progressWidth >= totalLen {
            progressWidth = totalLen
        }
        progressWidthConstraint.constant = progressWidth
        
        /// 设置主题颜色
        switch indexState {
        case .normal:
            setMainColor(blueColor)
            stateBtn.setTitle("Normal", for: .normal)
        case .high:
            setMainColor(orangeColor)
            stateBtn.setTitle("High", for: .normal)
        case .low:
            setMainColor(greenColor)
            stateBtn.setTitle("Low", for: .normal)
        }
        
        /// 设置指标状态框的位置
        stateBtnXConstraint.constant = progressWidth + 5
        
    }
    
    private func setMainColor(_ color: UIColor) {
        stateBtn.setTitleColor(color, for: .normal)
        stateBtn.layer.borderColor = color.cgColor
        stateBtn.setTitle("", for: .normal)
        progressView.backgroundColor = color
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
