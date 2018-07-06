//
//  XCRTitleScrollView.swift
//  XCar
//
//  Created by HuXiaoling on 16/7/22.
//  Copyright © 2016年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

import UIKit

/// 滚动标题视图
public class XCRTitleScrollView: UIScrollView {

    // MARK: - Property
    /// UI数据
    public var style: XCRTitleScrollViewStyle {
        didSet {
            updateTheme()
        }
    }
    /// 所有订阅频道标题
    public var titles: [String] = []
    /// 选中标题的回调
    public var handleSelectButton: ((_ selectedIndex: Int, _ selectedButton: UIButton) -> Void)?
    /// 分隔线
    private var separateLine: UIView!
    /// 标题下的标记线
    private var underLine: UIView!
    // 选中的按钮
    private var selectedButton: UIButton?
    /// 所有title控件
    private var titleButtons: [XCRRedPointTitleButton] = []

    // MARK: - Initialize
    public init(style: XCRTitleScrollViewStyle) {
        self.style = style
        super.init(frame: CGRect.zero)

        // 设置默认参数
        scrollsToTop = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        separateLine = UIView()
        separateLine.isHidden = style.hideSeparateLine
        addSubview(separateLine)

        underLine = UIView()
        underLine.isHidden = style.hideTitleUnderLine
        underLine.layer.cornerRadius = kCornerRadius
        underLine.layer.masksToBounds = true
        underLine.backgroundColor = style.selectedColor
        addSubview(underLine)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Handle Method
    private func buttonWithTag(tag: Int) -> XCRRedPointTitleButton {
        let button: XCRRedPointTitleButton = XCRRedPointTitleButton()
        button.isExclusiveTouch = true
        button.titleLabel?.font = style.tintFont
        button.addTarget(self, action: #selector(handleButtonClick(button:)), for: .touchUpInside)
        return button
    }

    @objc private func handleButtonClick(button: UIButton) {
        selectedTitle(at: button.tag, animated: true)
        if let callBack = handleSelectButton {
            callBack(button.tag, button)
        }
    }

    /// 刷新数据
    public func reloadTitles() {
        // 数量过多 移除
        while titles.count < titleButtons.count {
            let titleButton = titleButtons.last
            titleButton?.removeFromSuperview()
            titleButtons.removeLast()
        }

        layoutIfNeeded()

        var previousButton: UIButton?
        var xPostion = style.sideInset
        let height = frame.height
        let autoAdjustItemWidth = style.autoAdjustItemWidth
        let averageWidth = (frame.width - style.sideInset * 2 - style.itemSpace * CGFloat(titles.count - 1)) / CGFloat(titles.count)
        for (index, title) in titles.enumerated() {
            var button: XCRRedPointTitleButton
            if titleButtons.count > index {
                button = titleButtons[index]
                button.removeFromSuperview()
            } else {
                button = buttonWithTag(tag: index)
                titleButtons.append(button)
            }
            button.tag = index
            button.setTitleColor(style.normalColor, for: .normal)
            button.transform = CGAffineTransform.identity
            button.setTitle(title, for: .normal)
            button.redPointView.isHidden = true
            addSubview(button)

            if let previousButton = previousButton {
                xPostion = previousButton.frame.maxX + style.itemSpace
            }
            let width = autoAdjustItemWidth ? button.intrinsicContentSize.width : averageWidth
            button.frame = CGRect(x: xPostion, y: 0, width: width, height: height)
            previousButton = button
        }

        separateLine.frame = CGRect(x: 0.0, y: height - kOnePixel, width: frame.width, height: kOnePixel)
        let underLineHeight: CGFloat = 2.0
        underLine.frame = CGRect(x: 0, y: height - underLineHeight - 8, width: 0, height: underLineHeight)
        if let previousButton = previousButton {
            contentSize = CGSize(width: previousButton.frame.maxX + style.sideInset, height: 0)
        } else {
            contentSize = CGSize(width: style.sideInset, height: 0)
        }
        selectedTitle(at: 0, animated: false)
    }

    /// 选中标题
    public func selectedTitle(at index: Int, animated: Bool = true) {
        if !(index >= 0 && index < titleButtons.count) {
            return
        }

        selectedButton?.setTitleColor(style.normalColor, for: .normal)
        let button = titleButtons[index]
        button.setTitleColor(style.selectedColor, for: .normal)

        let intrinsicWidth = button.intrinsicContentSize.width
        let duration = animated ? 0.25 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.underLine.frame.size.width = intrinsicWidth * 0.4
            self.underLine.center.x = button.center.x
            self.selectedButton?.transform = CGAffineTransform.identity
            button.transform = CGAffineTransform(scaleX: self.style.itemScale, y: self.style.itemScale)
        })

        let offsetX = min(button.frame.midX - frame.width * 0.5, contentSize.width - frame.width)
        let x = max(offsetX, 0)
        setContentOffset(CGPoint(x: x, y: 0), animated: animated)

        selectedButton = button
    }

    /// 标题随动
    public func scrollTitleButton(_ contentOffsetX: CGFloat) {
        if contentOffsetX < 0 || contentOffsetX > CGFloat(titleButtons.count - 1) * kScreenWidth {
            return
        }

        let leftIndex = Int(contentOffsetX) / Int(kScreenWidth)
        let rightIndex = leftIndex + 1
        if leftIndex < 0 || rightIndex >= titleButtons.count {
            return
        }

        let leftButton = titleButtons[leftIndex]
        let rightButton = titleButtons[rightIndex]

        let ratio = CGFloat((Int(contentOffsetX) % Int(kScreenWidth))) / kScreenWidth
        underLine.center.x = leftButton.center.x + (rightButton.center.x - leftButton.center.x) * ratio
        underLine.frame.size.width = (leftButton.intrinsicContentSize.width + (rightButton.intrinsicContentSize.width - leftButton.intrinsicContentSize.width) * ratio) * 0.4

        let transformScale = style.itemScale - 1
        let scaleR = contentOffsetX / kScreenWidth - CGFloat(leftIndex)
        let scaleL = 1 - scaleR
        let leftScale = scaleL * transformScale + 1
        let rightScale = scaleR * transformScale + 1
        leftButton.transform = CGAffineTransform(scaleX: leftScale, y: leftScale)
        rightButton.transform = CGAffineTransform(scaleX: rightScale, y: rightScale)

        let rightColor = shadeColor(style.normalColor, toColor: style.selectedColor, ratio: ratio, revert: true, calculate: -)
        rightButton.setTitleColor(rightColor, for: .normal)
        let leftColor = shadeColor(style.normalColor, toColor: style.selectedColor, ratio: ratio, revert: false, calculate: +)
        leftButton.setTitleColor(leftColor, for: .normal)
    }

    /// 渐变标题颜色
    private func shadeColor(_ fromColor: UIColor, toColor: UIColor, ratio: CGFloat, revert: Bool, calculate: ((CGFloat, CGFloat) -> CGFloat)) -> UIColor {
        var fRed: CGFloat = 0, fGreen: CGFloat = 0, fBlue: CGFloat = 0, fAlpha: CGFloat = 0
        var tRed: CGFloat = 0, tGreen: CGFloat = 0, tBlue: CGFloat = 0, tAlpha: CGFloat = 0
        fromColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        toColor.getRed(&tRed, green: &tGreen, blue: &tBlue, alpha: &tAlpha)
        let red = calculate(revert ? fRed : tRed, (fRed - tRed) * ratio)
        let green = calculate(revert ? fGreen : tGreen, (fGreen - tGreen) * ratio)
        let blue = calculate(revert ? fBlue : tBlue, (fBlue - tBlue) * ratio)
        let alpha = calculate(revert ? fAlpha : tAlpha, (fAlpha - tAlpha) * ratio)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 标题红点
    public func showRedPoint(with indexArray: [Int]) {
        for index in indexArray {
            if !(index >= 0 && index < titleButtons.count) {
                continue
            }
            titleButtons[index].redPointView.isHidden = false
        }
    }

    public func hideRedPoint(with indexArray: [Int]) {
        for index in indexArray {
            if !(index >= 0 && index < titleButtons.count) {
                continue
            }
            titleButtons[index].redPointView.isHidden = true
        }
    }

    // MARK: - Theme
    public func updateTheme() {
        separateLine.backgroundColor = UIColor.cE6E6E6
        underLine.backgroundColor = style.selectedColor
        for button in titleButtons {
            button.setTitleColor(style.normalColor, for: .normal)
        }
        selectedButton?.setTitleColor(style.selectedColor, for: .normal)
    }

    // MARK: - GC
    deinit {}
}
