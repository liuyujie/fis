//
//  UIAlertController.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import UIKit

extension UIAlertController {
    /// Easy way to present UIAlertController
    public func show() {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}
