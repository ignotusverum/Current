//
//  EntitiesUtil.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait, Element == Data {
    func decode<T: Decodable>(decoder: JSONDecoder? = nil) -> Single<T> {
        let defaultDecoder = JSONDecoder()
        
        return map {
            try (decoder ?? defaultDecoder)
                .decode(T.self, from: $0)
        }
    }
}
