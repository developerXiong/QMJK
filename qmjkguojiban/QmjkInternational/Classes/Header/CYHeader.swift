//
//  CYHeader.swift
//  QmjkInternational
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/9/18.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

import Foundation
import UIKit


// MARK: 打印
//func debugPrint(_ items: Any...) { if true { print(items) } }

// MARK: 颜色相关

/// 设置颜色
///
/// 跟颜色相关的所有快捷变量
///
/// - Parameters:
///   - r: red
///   - g: green
///   - b: blue
///   - a: alaph
/// - Returns: UIColor
func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
let blueColor: UIColor = rgbColor(r: 37.0, g: 153.0, b: 237.0, a: 1.0)
let orangeColor: UIColor = rgbColor(r: 251.0, g: 181.0, b: 97.0, a: 1.0)
let greenColor: UIColor = rgbColor(r: 97.0, g: 224.0, b: 194.0, a: 1.0)

// MARK: 状态栏
func setStatusBar(to style: UIStatusBarStyle) {
    UIApplication.shared.statusBarStyle = style
}

// MARK: 导航栏
func setNavbarHidden(vc: UIViewController?, hidden: Bool) {
    guard let vc = vc else { return }
    vc.navigationController?.isNavigationBarHidden = hidden
}

func setNavbarTintColor(vc: UIViewController?, isNormal: Bool) {
    guard let vc = vc else { return }
    func setBarTintColor(_ isNormal: Bool) {
        vc.navigationController?.navigationBar.barTintColor = isNormal ? UIColor.white : blueColor
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : isNormal ? UIColor.black : UIColor.white]
        vc.navigationController?.navigationBar.tintColor = isNormal ? UIColor.black : UIColor.white
    }
}

/// 设置导航栏底部的线隐藏
func setNavbarBotLineHidden(vc: UIViewController?, hidden: Bool, imgV: UIImageView) {
    guard let vc = vc else { return }
    let navigationBar = vc.navigationController?.navigationBar;
    
    let imgView = findHairlineImageViewUnder(view: navigationBar!)
    imgView?.isHidden = hidden
}
func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
    if (view.isKind(of: UIImageView.self) && view.bounds.size.height <= 1.0) {
        return (view as! UIImageView)
    }
    for subview in view.subviews {
        let imageView = findHairlineImageViewUnder(view: subview);
        if imageView != nil {
            return imageView
        }
    }
    return nil;
}


// MARK: 渐变色
func setGragientColor(view: UIView?, colors: [CGColor]) {
    guard let view = view else { return }
    
    let layer = CAGradientLayer()
    layer.frame = view.frame
    layer.colors = colors
    view.layer.addSublayer(layer)
}


// MARK: UIView  extension
extension UIView {
    var LeftX: CGFloat {
        set {
            self.frame.origin.x = LeftX
        }
        get {
            return self.frame.origin.x
        }
    }
    var RightX: CGFloat {
        get {
            return self.frame.origin.x + self.bounds.width
        }
    }
    var TopY: CGFloat {
        set {
            self.frame.origin.y = TopY
        }
        get {
            return self.frame.origin.y
        }
    }
    var BottomY: CGFloat {
        set {
            self.TopY = BottomY - self.Height
        }
        get {
            return self.frame.origin.y + self.bounds.height
        }
    }
    var Width: CGFloat {
        set {
            self.frame.size.width = Width
        }
        get {
            return self.bounds.width
        }
    }
    var Height: CGFloat {
        set {
            self.frame.size.height = Height
        }
        get {
            return self.bounds.height
        }
    }
    var size: CGSize {
        set {
            self.Width = size.width
            self.Height = size.height
        }
        get {
            return self.bounds.size
        }
    }
}


// MARK: 求根据text求label的宽高
func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
    return stringSize.height
}

func getTextWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
    return stringSize.width
}

func getTextSize(textStr:String,font:CGFloat) -> CGSize {
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
    let dic = NSDictionary(object: UIFont.systemFont(ofSize: font), forKey: NSAttributedStringKey.font as NSCopying)
    return normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
}

// MARK: 尺寸相关
let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height

// MARK: 机型
enum IPHONEMODELNUMBER {
    case FIVE
    case SIX
    case PLUS
    case UNKNOMN
}
func IPHONEMODEL() -> IPHONEMODELNUMBER {
    if screenW == 320 {
        // 5
        return .FIVE
    } else if screenW == 375 {
        // 6
        return .SIX
    } else if screenW == 414 {
        return .PLUS
    } else {
        return .UNKNOMN
    }
}


