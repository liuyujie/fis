//
//  XCRTitleScrollViewStyle.swift
//  XCRTitleScrollView
//
//  Created by 胡晓玲 on 2017/12/7.
//

import UIKit

///屏幕宽
var kScreenWidth: CGFloat { return UIScreen.main.bounds.size.width }
///屏幕高
var kScreenHeight: CGFloat { return UIScreen.main.bounds.size.height }

public struct XCRTitleScrollViewStyle {
    /// 未选中标题颜色
    public var normalColor: UIColor = UIColor.cFFFFFF.withAlphaComponent(0.7)
    /// 选中标题颜色
    public var selectedColor: UIColor = UIColor.cFFFFFF
    /// 标题字号
    public var tintFont: UIFont = UIFont.middle
    /// 标题按钮的缩放比例
    public var itemScale: CGFloat = 1.1
    /// 是否隐藏分隔线
    public var hideSeparateLine: Bool = true
    /// 是否隐藏标题下的标记线
    public var hideTitleUnderLine: Bool = false
    /// 左右两侧的inset
    public var sideInset: CGFloat = 5.0
    /// 标题按钮之间的间距
    public var itemSpace: CGFloat = 20.0
    /// 标题按钮宽度是否固定：true-宽度自适应，false-宽度固定((宽度为父控件宽度 - sideInset - interItemSpacing * (标题个数 - 1)) / 标题个数)
    public var autoAdjustItemWidth: Bool = true

    public init() {}
}

public struct XCRTitleViewStyle {
    /// 未选中标题颜色
    public var normalColor: UIColor = UIColor.c44494D
    /// 选中标题颜色
    public var selectedColor: UIColor = UIColor.cFFFFFF
    /// 未选中标题背景色
    public var normalBackgroundColor: UIColor = UIColor.cFFFFFF
    /// 选中标题背景颜色
    public var selectedBackgroundColor: UIColor = UIColor.c1DA1F2
    /// 标题字号
    public var tintFont: UIFont = UIFont.middle
    /// 是否隐藏分隔线
    public var hideSeparateLine: Bool = true
    /// 左右两侧的inset
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    public init() {}
}
