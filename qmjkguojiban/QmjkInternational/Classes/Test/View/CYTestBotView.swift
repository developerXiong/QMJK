//
//  CYTestBotView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/20.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYTestBotView: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    let dataCount = 6       // 展示的数据的数量
    ///         心率      血氧   呼吸频率  低压   高压    pi
    let units = ["HR", "SPO2H", "RR", "SBP", "DBP", "PI"]  // 单位
    let images = [UIImage(named: "rate"), UIImage(named: "oxygen"), UIImage(named: "breath"), UIImage(named: "low"), UIImage(named: "high"), UIImage(named: "PI")]

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView(frame)
    }
    
    /// 初始化子视图
    private func initView(_ frame: CGRect) {
        scrollView = UIScrollView()
        pageControl = UIPageControl()
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        
        scrollView.contentSize = CGSize(width: screenW * 2, height: frame.size.height * 2 / 3)
        scrollView.backgroundColor = UIColor.clear
        scrollView.isPagingEnabled = true
        scrollView.contentMode = .center
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self as UIScrollViewDelegate
        for i in 0..<dataCount {
            let pageView = CYTestPageView()
            pageView.image = images[i]!
            pageView.tag = i
            pageView.valueLabel.text = "--"
            pageView.unitLabel.text = units[i]
            scrollView.addSubview(pageView)
        }
        
        
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
    }
    
    /// 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h = self.frame.size.height
        scrollView.frame = CGRect(x: 0, y: 0, width: screenW, height: h * 2 / 3)
        
        pageControl.frame = CGRect(x: (screenW-80)/2, y: scrollView.BottomY+5, width: 80, height: 10)
        
        for view in scrollView.subviews {
            if view.isKind(of: CYTestPageView.self) {
                let i: CGFloat = CGFloat(view.tag)
                let w = screenW / 3
                view.frame = CGRect(x: i * w, y: 0, width: w, height: scrollView.Height)
            }
        }
    }
    
    // MARK: scroll view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / screenW
        pageControl.currentPage = Int(index)
    }
    
    // MARK: 刷新数据
    func reloadData(with rate: Int, oxygen: Int, breath: Int, low: Int, high: Int, PI: Int) {
        for view in scrollView.subviews {
            if view.isKind(of: CYTestPageView.self) {
                let v = view as! CYTestPageView
                switch v.tag {
                case 0:
                    v.valueLabel.text = rate > 0 ? "\(rate)" : "--"
                case 1:
                    v.valueLabel.text = oxygen > 0 ? "\(oxygen)" : "--"
                case 2:
                    v.valueLabel.text = breath > 0 ? "\(breath)" : "--"
                case 3:
                    v.valueLabel.text = low > 0 ? "\(low)" : "--"
                case 4:
                    v.valueLabel.text = high > 0 ? "\(high)" : "--"
                case 5:
                    v.valueLabel.text = PI > 0 ? "\(PI)" : "--"
                default:
                    v.valueLabel.text = "--"
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
