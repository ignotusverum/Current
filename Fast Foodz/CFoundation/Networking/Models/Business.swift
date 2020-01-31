//
//  Business.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public enum BusinessType: String, Equatable {
    case mexican
    case pizza
    case chinese
    case burgers
}

public struct Business: BusinessProtocol, Decodable, Equatable {
    public let id: String
    public let alias: String
    public let name: String
    public let imagePath: String
    public let isClosed: Bool
    public let url: String
    public let rating: Float
    public let price: String?
    public let phone: String
    public let displayPhone: String
    public let distance: Float
    public let transactions: [String]
    public let categories: [Category]
    public let location: Location
    public let coordinates: Coordinates
    
    public var imageURL: URL? { URL(string: imagePath)}
    
    public var type: BusinessType? {
        categories.compactMap { BusinessType(rawValue: $0.alias) }.first
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case imagePath = "image_url"
        case isClosed = "is_closed"
        case url
        case rating
        case price
        case phone
        case displayPhone = "display_phone"
        case distance
        case transactions
        case categories
        case location
        case coordinates
    }
}
