//
//  XCRTheme.swift
//  XCRTheme
//
//  Created by Xcar iOS Team on 2017/11/29.
//  Copyright © 2017年 SAINADE(Beijing) Information Technology Co., Ltd. All rights reserved.
//

import UIKit

private class XCRII: NSObject {}

public struct XCRTheme {

    private static var themeBundle: Bundle? {
        let bundle = Bundle(for: XCRII.self)
        guard let bundleURL = bundle.url(forResource: "XCRTheme", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: bundleURL)
    }

    /// Default placeholder image
    public static var placeholderImage: UIImage? {
        if let bundle = themeBundle {
            return UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
        }
        return nil
    }

    /// Default user icon
    public static var defaultIconImage: UIImage? {
        if let bundle = themeBundle {
            return UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
        }
        return nil
    }
}

// MARK: - 主题颜色相关
extension XCRTheme {

    /// 红色 点击背景色 DC556F 
    public static var highlightedRedColor: UIColor {
        return UIColor(red: 0.83, green: 0.23, blue: 0.24, alpha: 1.00)
    }
    
    /// 详情页背景色 F9F9F9 黑色主题：28303D
    public static var detailBackgroundColor: UIColor {
        return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    }
    
    /// 辅助点击背景色 D7D9E0 黑色主题：191C21
    public static var auxiliarySeleftedBackgroundColor: UIColor {
        return UIColor(red: 0.84, green: 0.85, blue: 0.88, alpha: 1.00)
    }

    /// 白色文字颜色 FFFFFF 黑色主题：9DA2A5
    public static var whiteTextColor: UIColor {
        return UIColor.white
    }
   
    /// 文字点击颜色 000000 黑色主题：000000
    public static var highlightedTextColor: UIColor {
        return UIColor.black
    }
    
    /// 导航栏返回按钮色 5A5D5F 黑色主题：596672
    public static var navBackButtonColor: UIColor {
        return UIColor(red: 0.35, green: 0.36, blue: 0.37, alpha: 1.00)
    }
}
