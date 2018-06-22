//
//  NSObject.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

extension NSObject {

    public static var className: String {
        return String(describing: self)
    }
}
