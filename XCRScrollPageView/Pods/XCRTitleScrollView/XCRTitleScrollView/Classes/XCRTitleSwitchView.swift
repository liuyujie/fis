//
//  XCRTitleSwitchView.swift
//  XCRTitleScrollView
//
//  Created by 胡晓玲 on 2018/1/17.
//

import UIKit

/// 标题选择控件
public class XCRTitleSwitchView: UIView {
    // MARK: - Proterty
    private var titles: [String]
    private var titleButtons: [UIButton] = []
    private var itemSeparateLines: [UIView] = []
    private var contentView: UIView!
    private var separateLine: UIView!
    public var style: XCRTitleViewStyle
    public var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex { return }
            titleButtons[oldValue].isUserInteractionEnabled = true
            titleButtons[oldValue].isSelected = false
            titleButtons[selectedIndex].isUserInteractionEnabled = false
            titleButtons[selectedIndex].isSelected = true
        }
    }
    public var handleSelect: (( _ index: Int) -> Void)?

    // MARK: - Initialize
    public init(titles: [String], style: XCRTitleViewStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: CGRect.zero)
        commonInit()
        updateTheme()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        contentView = UIView()
        contentView.layer.cornerRadius = kCornerRadius
        contentView.layer.borderWidth = kOnePixel
        contentView.layer.masksToBounds = true

        separateLine = UIView()
        separateLine.isHidden = style.hideSeparateLine

        addSubview(contentView)
        addSubview(separateLine)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(12)
        }
        separateLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(kOnePixel)
        }

        var lastView: UIView?
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            button.isExclusiveTouch = true
            button.tag = index
            button.adjustsImageWhenHighlighted = false
            button.titleLabel?.font = style.tintFont
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(handleButtonClick(button:)), for: .touchUpInside)
            titleButtons.append(button)
            contentView.addSubview(button)

            var constraintItem: ConstraintItem
            if let lastView = lastView {
                constraintItem = lastView.snp.right
                let line = UIView()
                itemSeparateLines.append(line)
                contentView.addSubview(line)
                line.snp.makeConstraints({ (make) in
                    make.right.equalTo(button.snp.left)
                    make.centerY.height.equalTo(contentView)
                    make.width.equalTo(kOnePixel)
                })
            } else {
                constraintItem = contentView.snp.left
            }

            button.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(contentView)
                make.left.equalTo(constraintItem)
                make.width.equalTo(contentView).dividedBy(titles.count)
            })

            lastView = button
        }

        selectedIndex = 0
        titleButtons[selectedIndex].isUserInteractionEnabled = false
        titleButtons[selectedIndex].isSelected = true
    }

    @objc private func handleButtonClick(button: UIButton) {
        selectedIndex = button.tag
        guard let handleSelect = handleSelect else { return }
        handleSelect(selectedIndex)
    }

    // MARK: - Theme
    @objc public func updateTheme() {
        contentView.layer.borderColor = UIColor.cE6E6E6.cgColor
        separateLine.backgroundColor = UIColor.cE6E6E6
        for separateLine in itemSeparateLines {
            separateLine.backgroundColor = UIColor.cE6E6E6
        }
        for button in titleButtons {
            button.setTitleColor(style.normalColor, for: .normal)
            button.setTitleColor(style.selectedColor, for: .selected)
            button.setBackgroundColor(style.normalBackgroundColor, for: .normal)
            button.setBackgroundColor(style.selectedBackgroundColor, for: .selected)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
