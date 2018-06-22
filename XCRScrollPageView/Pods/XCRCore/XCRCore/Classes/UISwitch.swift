//
//  UISwitch.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import UIKit

extension UISwitch {

    /// toggles Switch
    public func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}
