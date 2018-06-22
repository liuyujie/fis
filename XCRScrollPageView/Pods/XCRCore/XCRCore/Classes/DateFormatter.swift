//
//  DateFormatter.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/27.
//

import UIKit

extension DateFormatter {

    public convenience init(format: String) {
        self.init()
        dateFormat = format
    }
}
