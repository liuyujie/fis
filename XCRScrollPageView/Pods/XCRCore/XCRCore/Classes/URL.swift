//
//  URL.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import UIKit

extension URL {
    /// Returns convert query to Dictionary
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }
}
