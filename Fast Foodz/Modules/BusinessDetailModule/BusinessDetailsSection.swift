//
//  BusinessDetailsSection.swift
//  BusinessDetailModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CFoundation

struct BusinessDetailsSection: Equatable {
    let imageURL: URL?
    var title: String
    var coordinates: Coordinates
    var phoneNumber: String
    
    init(model: Business) {
        imageURL = model.imageURL
        title = model.name
        coordinates = model.coordinates
        phoneNumber = model.phone
    }
}
