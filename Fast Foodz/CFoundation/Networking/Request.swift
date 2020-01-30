//
//  Request.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

public protocol FrameAPIRequest {
    var configure: RequestConfig { get }
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public struct RequestConfig {
    public var method: HTTPMethod
    public var path: String?
    public var parameters: Parameters?
    public var queryItems: [URLQueryItem]?
    
    public init(method: HTTPMethod,
                path: String? = nil,
                parameters: Parameters? = nil,
                queryItems: [URLQueryItem]? = nil) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.queryItems = queryItems
    }
}
