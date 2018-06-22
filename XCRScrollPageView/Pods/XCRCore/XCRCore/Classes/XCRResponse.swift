//
//  XCRResponse.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/7.
//
//

import UIKit

public class XCRResponse {

    public let code: Int
    public let message: String
    public let data: [String: Any]?
    public let request: URLRequest? = nil
    public let response: URLResponse? = nil

    /// Initialize a new `Response`.
    public init(statusCode: Int, message: String, data: [String: Any]? = nil, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.code = statusCode
        self.message = message
        self.data = data
    }

    private enum CodingKeys: String, CodingKey {
        case code = "status"
        case message = "msg"
        case data
    }
}
