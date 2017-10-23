//
//  CYCycleProgressView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/10.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

/// 如果继承UIView的话会造成界面卡顿,滚动屏幕的时候卡死.所以这里继承轻量级的CALayer解决卡顿
class CYCycleProgressView: CALayer {

    var rect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var value: CGFloat = 0 {
        didSet {
            rect = self.frame
            self.setNeedsDisplay()
        }
    }
    
    //线宽度
    var lineWidth: CGFloat = 10.0
    
    var maximumValue: CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        self.backgroundColor = UIColor.red
//        self.isOpaque = false
//        if screenW == 320 {
//            // 5s
//            lineWidth = 8.0
//        } else if screenW == 375 {
//            // 6
//            lineWidth = 10.0
//        } else if screenW == 414 {
//            lineWidth = 12.0
//        }
//        switch IPHONEMODEL() {
//        case .FIVE:
//            lineWidth = 8.0
//        case .SIX:
//            lineWidth = 10.0
//        case .PLUS:
//            lineWidth = 12.0
//        case .UNKNOMN:
//            lineWidth = 10.0
//        }
//    }
    
    override init() {
        super.init()
        
        // 解决锯齿模糊
        self.contentsScale = UIScreen.main.scale
        self.backgroundColor = UIColor.clear.cgColor
//        self.isOpaque = false
        if screenW == 320 {
            // 5s
            lineWidth = 8.0
        } else if screenW == 375 {
            // 6
            lineWidth = 10.0
        } else if screenW == 414 {
            lineWidth = 12.0
        }
        switch IPHONEMODEL() {
        case .FIVE:
            lineWidth = 8.0
        case .SIX:
            lineWidth = 10.0
        case .PLUS:
            lineWidth = 12.0
        case .UNKNOMN:
            lineWidth = 10.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        //半径
        let radius = rect.width / 2.0 - lineWidth
        //中心点x
        let centerX = rect.midX
        //中心点y
        let centerY = rect.midY
        //弧度起点
        let startAngle = CGFloat(-90 * Double.pi / 180)
        //弧度终点
        let endAngle = CGFloat(((self.value / self.maximumValue) * 360.0 - 90.0) ) * CGFloat(Double.pi) / 180.0
        
        //创建一个画布
//        let context = UIGraphicsGetCurrentContext()
        
        //画笔颜色
        ctx.setStrokeColor(rgbColor(r: 116, g: 195, b: 250, a: 1).cgColor)
        
        //画笔宽度
        ctx.setLineWidth(lineWidth)
        
        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
        ctx.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        //绘制路径
        ctx.strokePath()
        
        //画笔颜色
        ctx.setStrokeColor(UIColor.clear.cgColor)
        
        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
        ctx.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制路径
        ctx.strokePath()
    }
    
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        super.draw(rect)
//
//        //半径
//        let radius = rect.width / 2.0 - lineWidth
//        //中心点x
//        let centerX = rect.midX
//        //中心点y
//        let centerY = rect.midY
//        //弧度起点
//        let startAngle = CGFloat(-90 * Double.pi / 180)
//        //弧度终点
//        let endAngle = CGFloat(((self.value / self.maximumValue) * 360.0 - 90.0) ) * CGFloat(Double.pi) / 180.0
//
//        //创建一个画布
//        let context = UIGraphicsGetCurrentContext()
//
//        //画笔颜色
//        context!.setStrokeColor(rgbColor(r: 116, g: 195, b: 250, a: 1).cgColor)
//
//        //画笔宽度
//        context!.setLineWidth(lineWidth)
//
//        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
//        context?.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//
//        //绘制路径
//        context!.strokePath()
//
//        //画笔颜色
//        context!.setStrokeColor(UIColor.clear.cgColor)
//
//        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
//        context?.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//
//        //绘制路径
//        context!.strokePath()
//    }

}
