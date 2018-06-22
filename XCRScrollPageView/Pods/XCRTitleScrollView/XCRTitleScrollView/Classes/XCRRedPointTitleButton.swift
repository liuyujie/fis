//
//  XCRRedPointTitleButton.swift
//  Pods-XCRTitleScrollView_Example
//
//  Created by 胡晓玲 on 2018/4/17.
//

import UIKit

class XCRRedPointTitleButton: UIButton {
    private(set) var redPointView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        redPointView = UIView()
        redPointView.isHidden = true
        redPointView.backgroundColor = UIColor.cFC4840
        redPointView.layer.cornerRadius = 3
        redPointView.layer.masksToBounds = true
        addSubview(redPointView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let guideFrame = titleLabel?.frame ?? frame
        redPointView.frame = CGRect(x: guideFrame.maxX, y: guideFrame.minY - 6, width: 6, height: 6)
    }
}
