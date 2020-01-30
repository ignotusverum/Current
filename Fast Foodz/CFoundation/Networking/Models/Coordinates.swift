//
//  Corrdinates.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Coordinates: CoordinatesProtocol, Decodable {
    public let latitude: String
    public let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
