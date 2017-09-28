//
//  CYAlertView.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/22.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import UIKit

import ToastSwiftFramework

class CYAlertView: NSObject {

    // MARK: 只显示文字
    
    static func showText(_ text: String, on view: UIView) {
        view.makeToast(text)
    }
    
    static func showText(_ text: String, on view: UIView, duration: TimeInterval, position: CGPoint) {
        view.makeToast(text, duration: duration, position: position)
    }
    
    static func showText(_ text: String, on view: UIView, duration: TimeInterval, position: ToastPosition) {
        view.makeToast(text, duration: duration, position: position)
    }
    
    static func showText(_ text: String, on view: UIView, duration: TimeInterval, position: CGPoint, style: ToastStyle?) {
        view.makeToast(text, duration: duration, position: position, style: style)
    }
    
    static func showText(_ text: String, on view: UIView, duration: TimeInterval, position: ToastPosition, style: ToastStyle?) {
        view.makeToast(text, duration: duration, position: position, style: style)
    }
    
    static func showText(_ text: String?, on view: UIView, duration: TimeInterval, position: CGPoint, title: String?, image: UIImage?, style: ToastStyle?, completion: ((Bool) -> Void)?) {
        view.makeToast(text, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
    }
    
    static func showText(_ text: String, on view: UIView, duration: TimeInterval, position: ToastPosition, title: String?, image: UIImage?, style: ToastStyle?, completion: ((Bool) -> Void)?) {
        view.makeToast(text, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
    }
    
    
    // MARK: 转菊花
    
    static func showActivity(on view: UIView, position: CGPoint) {
        view.makeToastActivity(position)
    }
    
    static func showActivity(on view: UIView, position: ToastPosition) {
        view.makeToastActivity(position)
    }
    
    static func hideToastActivity(on view: UIView) {
        view.hideToastActivity()
    }
    
    // MARK: 显示自定义的view
    
    static func showCustomView(_ customView: UIView, on view: UIView) {
        view.showToast(customView)
    }
    
    static func showCustomView(_ customView: UIView, on view: UIView, duration: TimeInterval, position: CGPoint, completion: ((Bool) -> Void)?) {
        view.showToast(customView, duration: duration, position: position, completion: completion)
    }
    
    static func showCustomView(_ customView: UIView, on view: UIView, duration: TimeInterval, position: ToastPosition, completion: ((Bool) -> Void)?) {
        view.showToast(customView, duration: duration, position: position, completion: completion)
    }
    
    // MARK: 系统弹框
    
    static func showSystemAlert(on vc: UIViewController, title: String?, message: String?, sureHandler: ((_ action: UIAlertAction) -> ())?, cancelHandler: ((_ action: UIAlertAction) -> ())?) {
        let control = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default) { (action) in
            if sureHandler != nil {
                sureHandler!(action)
            }
        }
        let action1 = UIAlertAction(title: "NO", style: .cancel) { (action) in
            if cancelHandler != nil {
                cancelHandler!(action)
            }
        }
        
        control.addAction(action)
        control.addAction(action1)
        vc.present(control, animated: true, completion: nil)
    }
    
}
