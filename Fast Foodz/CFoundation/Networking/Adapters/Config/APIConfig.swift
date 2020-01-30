//
//  APIConfig.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public struct APIConfig {
    public var path: String
    public init(path: String) {
        self.path = path
    }
}

enum MainAPIConfig {
    case businesses
    
    func config() -> APIConfig {
        switch self {
        case .businesses: return APIConfig(path: "v3/businesses/search")
        }
    }
}

public protocol MainAPIConfigurable where Self: NetworkingConfigurable {
    static var apiConfig: APIConfig { get }
}

