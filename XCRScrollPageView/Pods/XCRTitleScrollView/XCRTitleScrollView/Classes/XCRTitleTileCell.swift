//
//  XCRTitleTileCell.swift
//  XCRTitleScrollView
//
//  Created by 胡晓玲 on 2017/12/8.
//

import UIKit

/// 平铺标题视图 - cell
class XCRTitleTileCell: UICollectionViewCell {

    // MARK: - Property
    private(set) var titleLabel: UILabel!

    var hasSelected: Bool = false {
        didSet {
            updateTheme()
        }
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        updateTheme()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        layer.cornerRadius = kCornerRadius
        layer.masksToBounds = true

        titleLabel = UILabel()
        titleLabel.font = UIFont.small
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.layer.cornerRadius = kCornerRadius
        titleLabel.layer.masksToBounds = true

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }

    // MARK: - Theme
    @objc internal func updateTheme() {
        backgroundColor = hasSelected ? UIColor.c1DA1F2 : UIColor.cF4F6F9
        titleLabel.textColor = hasSelected ? UIColor.cFFFFFF : UIColor.c181818
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
