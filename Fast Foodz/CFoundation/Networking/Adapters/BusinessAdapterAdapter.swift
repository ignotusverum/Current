//
//  BusinessAdapter.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

import RxSwift

public protocol BusinessNetworkingProtocol where Self: NetworkingAdapter {
    static func fetch()-> Single<BusinessesPage>
}

public class BusinessAdapter: NetworkingAdapter {
    public var settings: AdapterConfig!
    private static var adapter: BusinessAdapter!
    
    @discardableResult
    public init(config: AdapterConfig) {
        settings = config
        BusinessAdapter.adapter = self
    }
}

extension BusinessAdapter: BusinessNetworkingProtocol {
    public static func fetch() -> Single<BusinessesPage> {
        let config = Requests
            .fetch
            .configure
        
        return adapter
            .request(config)
            .decode()
    }
}

private extension BusinessAdapter {
    enum Requests: FrameAPIRequest {
        case fetch
        
        public var configure: RequestConfig {
            switch self {
            case .fetch:
                return RequestConfig(method: .get,
                                     queryItems: [URLQueryItem(name: "longitude",
                                                               value: "-73.985130"),
                                                  URLQueryItem(name: "latitude",
                                                               value: "40.758896"),
                                                  URLQueryItem(name: "radius",
                                                               value: "1000"),
                                                  URLQueryItem(name: "sort_by",
                                                               value: "distance"),
                                                  URLQueryItem(name: "categories",
                                                               value: "pizza,mexican,chinese,burgers")
                    ],
                                     customHeaders: adapter.settings.headers)
            }
        }
    }
}

