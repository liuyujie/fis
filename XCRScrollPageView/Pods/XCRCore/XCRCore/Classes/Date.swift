//
//  Date.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import Foundation

extension Date {

    /// Initializes Date from string and format
    public init?(fromString string: String, format: String) {
        if let date = DateFormatter(format: format).date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    // Check date if it is today
    public var isToday: Bool {
        let format = DateFormatter(format: "yyyy-MM-dd")
        return format.string(from: self) == format.string(from: Date())
    }

    /// Check date if it is yesterday
    public var isYesterday: Bool {
        let format = DateFormatter(format: "yyyy-MM-dd")
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return format.string(from: self) == format.string(from: yesterDay!)
    }

    /// Get the year from the date
    public var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }

    /// Get the month from the date
    public var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }

    /// Get the weekday from the date
    public var weekday: String {
        return DateFormatter(format: "EEEE").string(from: self)
    }

    // Get the month from the date
    public var monthAsString: String {
        return DateFormatter(format: "MMMM").string(from: self)
    }

    // Get the day from the date
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// Get the hours from date
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    /// Get the minute from date
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    /// Get the second from the date
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }

    /// Gets the nano second from the date
    public var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
}
