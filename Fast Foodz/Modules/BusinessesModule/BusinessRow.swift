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
    let title: String
    let subtitle: String
    
    let imageUrl: URL?
    
    init(model: Business) {
        type = .mexican
        imageUrl = model.imageURL
        
        title = model.name
        
        let distance = "\(Int(model.distance)) miles"
        if let price = model.price {
            subtitle = "\(price) * \(distance)"
        } else {
            subtitle = "\(distance)"
        }
    }
}
