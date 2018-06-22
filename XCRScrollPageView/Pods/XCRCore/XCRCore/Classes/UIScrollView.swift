//
//  UIScrollView.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/19.
//

import UIKit

extension UIScrollView {

    public enum Edge {
        case top
        case left
        case bottom
        case right
    }

    public func scroll(edege: Edge, animated: Bool = true) {
        var offset = self.contentOffset
        switch edege {
        case .top:
            offset.y =  -self.contentInset.top
        case .left:
            offset.x = -self.contentInset.left
        case .bottom:
            offset.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
        case .right:
            offset.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right
        }
        self.setContentOffset(offset, animated: animated)
    }

}
