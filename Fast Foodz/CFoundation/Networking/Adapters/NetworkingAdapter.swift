//
//  NetworkingAdapter.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import RxSwift

public struct AdapterConfig {
    public var base: String
    public var name: String
    
    public init(base: String,
                name: String) {
        self.base = base
        self.name = name
    }
}

public protocol NetworkingAdapter {
    var settings: AdapterConfig! { get }
    func configurator()
}

public extension NetworkingAdapter {
    func configurator() {}
    
    /// Generate component for the API request
    func generateRequestComponents(_ request: RequestConfig? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = settings.base
        
        var pathItems: [String] = []
        
        pathItems.append(contentsOf: [settings.name])
        if let path = request?.path { pathItems.append(path) }
        
        components.queryItems = request?.queryItems
        
        let cleanedPath = pathItems
            .filter { !$0.isEmpty }
            .joined(separator: "/")
        
        components.path = "/\(cleanedPath)"

        return components
    }
    
    func request(_ request: RequestConfig) -> Single<Data> {
        let components = generateRequestComponents(request)
        
        let apiMan = APIManager.shared
        return apiMan.request(for: components,
                              config: request)
    }
}

