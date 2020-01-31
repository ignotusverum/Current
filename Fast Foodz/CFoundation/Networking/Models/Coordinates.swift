//
//  Corrdinates.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public struct Coordinates: CoordinatesProtocol, Decodable, Equatable {
    public let latitude: Float
    public let longitude: Float
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
