//
//  UIFont.swift
//  XCRTheme
//
//  Created by Xcar iOS Team on Nov 29, 2017.
//  Copyright © 2017年 SAINADE(Beijing) Information Technology Co., Ltd. All rights reserved.
//

import UIKit

private let isiPhone4 = (CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode!.size))
private let isiPhone5 = (CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode!.size))

extension UIFont {

    /// 粗超超大号字体 24
    public static var boldSuperBigLarge: UIFont = UIFont.boldSystemFont(ofSize: 24)

    /// 超超大号字体 24
    public static var superBigLarge: UIFont = UIFont.systemFont(ofSize: 24)

    /// 超大号字体 21
    public static var bigLarge: UIFont = UIFont.systemFont(ofSize: 21)

    /// 大号字体 18
    public static var large: UIFont = UIFont.systemFont(ofSize: 18)

    /// 粗正常字体 18 iPhone4/5字体为16
    public static var boldLarge: UIFont = isiPhone4 || isiPhone5 ? boldSystemFont(ofSize: 16) : boldSystemFont(ofSize: 18)

    /// 次大号字体 17 iPhone4/5字体为16
    public static var big: UIFont = isiPhone4 || isiPhone5 ? UIFont.systemFont(ofSize: 16) : UIFont.systemFont(ofSize: 17)

    /// 正常字体 16 iPhone4/5字体为15
    public static var normal: UIFont = isiPhone4 || isiPhone5 ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 16)

    /// 粗正常字体 16 iPhone4/5字体为15
    public static var boldNormal: UIFont = isiPhone4 || isiPhone5 ? UIFont.boldSystemFont(ofSize: 15) : UIFont.boldSystemFont(ofSize: 16)

    /// 中号字体 15 iPhone4/5字体为14
    public static var middle: UIFont = isiPhone4 || isiPhone5 ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 15)

    /// 小号字体 14 iPhone4/5字体为13
    public static var small: UIFont = isiPhone4 || isiPhone5 ? UIFont.systemFont(ofSize: 13) : UIFont.systemFont(ofSize: 14)

    /// 粗小号字体 14 iPhone4/5字体为13
    public static var boldSmall: UIFont = isiPhone4 || isiPhone5 ? UIFont.boldSystemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 14)

    /// 中小号字体 13 iPhone4/5字体为12
    public static var middleSmall: UIFont = isiPhone4 || isiPhone5 ? UIFont.systemFont(ofSize: 12) : UIFont.systemFont(ofSize: 13)

    /// 小号字体 12
    public static var little: UIFont = UIFont.systemFont(ofSize: 12)

    /// 粗小号字体 12
    public static var boldLittle = UIFont.boldSystemFont(ofSize: 12)

    /// 迷你字体 10
    public static var mini: UIFont = UIFont.systemFont(ofSize: 10)

}
