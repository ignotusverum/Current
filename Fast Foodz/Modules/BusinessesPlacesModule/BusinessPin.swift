//
//  BusinessPin.swift
//  BusinessesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import CFoundation

struct BusinessPin: Equatable {
    var title: String
    var coordinates: Coordinates
    
    init(model: Business) {
        title = model.name
        coordinates = model.coordinates
    }
}
