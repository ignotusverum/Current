//
//  Location.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Location: LocationProtocol, Decodable {
    public let address1: String
    public let address2: String
    public let city: String
    public let zipCode: String
    public let country: String
    public let state: String
    public let displayAddresses: [String]
    
    enum CodingKeys: String, CodingKey {
        case address1
        case address2
        case city
        case zipCode
        case country
        case state
        case displayAddresses
    }
}
