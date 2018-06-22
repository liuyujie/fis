//
//  UIEdgeInsets.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import UIKit

extension UIEdgeInsets {
    /// Easier initialization of UIEdgeInsets
    public init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
}
