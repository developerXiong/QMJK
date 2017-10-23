//
//  CYWaveView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/10/10.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit


/// 如果继承UIView的话会造成界面卡顿,滚动屏幕的时候卡死.所以这里继承轻量级的CALayer解决卡顿
class CYWaveView: CALayer {
    
    var maxValue: CGFloat? {
        didSet {
            max = maxValue
        }
    }
    var minValue: CGFloat? {
        didSet {
            min = minValue
        }
    }
    private var max: CGFloat!
    private var min: CGFloat!

    let margin: CGFloat = 20   // 两条波形之间的距离
    var drawPoints1 = [CGPoint]()
    var drawPoints2 = [CGPoint]()
    var value = 0 {
        didSet {
            hanlePoint()
            totalHeight = self.frame.size.height
        }
    }
    var perviousValue: CGFloat = 0
    
    let currentX: CGFloat = 0
    let moveX: CGFloat = 0.2    // 每次移动的x值
    var lastPoint: CGPoint!
    var totalHeight: CGFloat = 0
    
//    var context: CGContext!

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.clearsContextBeforeDrawing = true
//        self.backgroundColor = UIColor.clear
//        lastPoint = CGPoint(x: -moveX, y: 25)
//        totalHeight = self.frame.size.height
//        max = 20000
//        min = 10000
//    }
    
    override init() {
        super.init()
//        self.clearsContextBeforeDrawing = true
        self.backgroundColor = UIColor.clear.cgColor
        lastPoint = CGPoint(x: -moveX, y: 25)
        
        // 解决锯齿模糊
//        self.contentsScale = UIScreen.main.scale
        maxValue = 30000
        minValue = 8000
        max = 30000
        min = 8000
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        let lineWidth: CGFloat = 1.0
        // 线条颜色
        ctx.setStrokeColor(UIColor.white.cgColor)
        // 设置线条平滑，不需要两边像素宽
        //        context.setShouldAntialias(false)
        // 设置线条宽度
        ctx.setLineWidth(lineWidth)
        // 添加路径
        ctx.addLines(between: self.drawPoints1)
        ctx.addLines(between: self.drawPoints2)
        // 开始画线
        ctx.strokePath()
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        self.context = UIGraphicsGetCurrentContext()!
////        DispatchQueue.global().async {
//            // 获取画布
//            //线宽度
//            let lineWidth: CGFloat = 1.0
//            // 线条颜色
//            self.context.setStrokeColor(UIColor.white.cgColor)
//            // 设置线条平滑，不需要两边像素宽
//            //        context.setShouldAntialias(false)
//            // 设置线条宽度
//            self.context.setLineWidth(lineWidth)
//            // 添加路径
//            self.context.addLines(between: self.drawPoints1)
//            self.context.addLines(between: self.drawPoints2)
//            // 开始画线
//            self.context.strokePath()
////        }
//
//    }
    
    /// 处理传进来的值 转换为坐标点
    private func hanlePoint() {
        let x = self.lastPoint.x + self.moveX
        let y = self.handleValue(value)
        let point = CGPoint(x: x, y: y)
        self.lastPoint = point
        if x >= screenW {
            self.lastPoint.x = -moveX
        }
        
        
        /// 处理坐标点数组
        // 0 <= lastX < screenW-margin :数组1 只加不减
        // screenW-margin <= lastX < screenW :数组1 又加又减
        // screenW <= lastX :数组1 只减不加   并且开始向数组2添加坐标
        var lastX: CGFloat = 0 // 坐标点数组1最后一个点的x值
        if drawPoints1.count > 0 {
            lastX = (drawPoints1.last?.x)!
        }
        if lastX>=0 && lastX<screenW-margin {
            // 数组1 只加不减
            drawPoints1.append(point)
        } else if lastX>=screenW-margin && lastX<screenW {
            // 数组1 又加又减
            drawPoints1.append(point)
            drawPoints1.remove(at: 0)
        } else {
            // 数组1 只减不加
            drawPoints1.remove(at: 0)
            // 向坐标点数组2添加坐标
            drawPoints2.append(point)
            // 如果数组1的坐标点移除完了,将数组2的坐标点给数组1并清空数组2
            if drawPoints1.count <= 0 {
//                drawPoints1.append(contentsOf: drawPoints1)
                drawPoints1 = drawPoints2
                drawPoints2.removeAll()
            }
        }
        
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    /// 20000  40000
    private func handleValue(_ value: Int) -> CGFloat {
        var v: CGFloat = CGFloat(value)
        
//        if v > 37000 || v < 5000 {
//            v = perviousValue
//        }
//        perviousValue = v
        
        v = (v - min) * totalHeight / (max - min)
        
        return totalHeight - v
    }
    
}
