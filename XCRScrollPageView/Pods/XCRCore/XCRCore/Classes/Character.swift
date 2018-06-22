//
//  Character.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import Foundation

extension Character {
    /// Converts Character to String
    public var toString: String { return String(self) }

    /// If the character represents an integer that fits into an Int, returns the corresponding integer.
    public var toInt: Int? { return Int(String(self)) }

    /// Checks if character is emoji
    var isEmoji: Bool {
        return String(self).includesEmoji()
    }
}
