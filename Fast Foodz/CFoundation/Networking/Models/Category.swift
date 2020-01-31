//
//  Category.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Category: CategoryProtocol, Decodable, Equatable {
    public let alias: String
    public let title: String
    
    enum CodingKeys: String, CodingKey {
        case alias
        case title
    }
}
