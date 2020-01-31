//
//  Business.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Business: BusinessProtocol, Decodable {
    public let id: String
    public let alias: String
    public let name: String
    public let imageUrl: String
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case imageUrl = "image_url"
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
