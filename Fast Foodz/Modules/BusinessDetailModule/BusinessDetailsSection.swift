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
    var location: Location
    var phoneNumber: String
    
    init(model: Business) {
        imageURL = model.imageURL
        title = model.name
        location = model.location
        phoneNumber = model.phone
    }
}
