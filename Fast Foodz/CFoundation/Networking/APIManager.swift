//
//  APIManager.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final public class APIManager {
    public static let shared = APIManager(session: URLSession.shared)
    
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public func request(for component: URLComponents,
                        config: RequestConfig) -> Single<Data> {
        guard let path = component.url?.absoluteString,
            let url = URL(string: path) else {
            return .error(ApplicationError.apiError(type: .commonError))
        }

        let request = prepareRequest(method: config.method,
                                     url: url,
                                     parameters: config.parameters,
                                     headers: config.customHeaders ?? [:])

        return session.rx
            .apiData(request: request)
            .asSingle()
    }

    private func prepareRequest(method: HTTPMethod,
                                url: URL,
                                parameters: Parameters? = nil,
                                headers: HTTPHeaders) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        for pair in headers {
            request.setValue(pair.value, forHTTPHeaderField: pair.key)
        }
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters,
                                                           options: .sortedKeys)
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
            }
        }
        
        return request
    }
}

extension Reactive where Base: URLSession {
    public func apiData(request: URLRequest) -> Observable<Data> {
        return response(request: request).map { response, data -> Data in
            if 200 ..< 300 ~= response.statusCode {
                return data
            } else {
                throw ApplicationError.apiError(type: .responseError(error: String(data: data,
                                                                                   encoding: .utf8)))
            }
        }
    }
}

