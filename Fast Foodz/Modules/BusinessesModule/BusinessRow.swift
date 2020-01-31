//
//  BusinessRow.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CFoundation
import RxDataSources

enum BusinessType: String, Equatable {
    case mexican
    case pizza
    case chinese
    case burger
    case undefined
}

struct BusinessRow: Equatable {
    let type: BusinessType
    let price: String
    let title: String
    let distance: String
    
    let imageUrl: URL?
    
    init(model: Business) {
        type = .mexican
        imageUrl = model.imageURL
        price = model.price ?? "-"
        title = model.name
        distance = "\(Int(model.distance)) miles"
    }
}
