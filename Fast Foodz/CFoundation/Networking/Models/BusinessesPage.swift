//
//  BusinessesPage.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct BusinessesPage: Decodable {
    public let items: [Business]
    
    enum CodingKeys: String, CodingKey {
        case businesses
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Business].self, forKey: .businesses)
    }
}
