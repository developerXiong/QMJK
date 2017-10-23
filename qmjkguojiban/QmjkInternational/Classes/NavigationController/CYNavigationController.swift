//
//  CYNavigationController.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/20.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

class CYLoginNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "图层-3"), style: .plain, target: self, action: #selector(backAction))
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "图层-3"), style: .plain, target: self, action: #selector(backAction))
        
        
        super.pushViewController(viewController, animated: animated)
    }
    
    /// 解决自定义返回按钮样式之后不能滑动返回
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 { return false }
        return true
    }
    
    @objc func backAction() {
        self.popViewController(animated: true)
    }
    
    
    
    
}



class CYMainNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    var isCanUseGresture: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "图层-76"), style: .plain, target: self, action: #selector(backAction))
    }
    
    
    /// 解决自定义返回按钮样式之后不能滑动返回
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if !isCanUseGresture { return false }
        if self.childViewControllers.count == 1 { return false }
        return true
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        debugPrint("hehe")
    }
     */
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "图层-76"), style: .plain, target: self, action: #selector(backAction))

        
        super.pushViewController(viewController, animated: animated)
    }
    
   
    @objc func backAction() {
        if (self.childViewControllers.last?.isKind(of: CYHistoryListViewController.self))! {
            /// 历史记录界面直接跳转到首页
            self.popToRootViewController(animated: true)
        } else {
            self.popViewController(animated: true)
        }
    }
    
    
}
