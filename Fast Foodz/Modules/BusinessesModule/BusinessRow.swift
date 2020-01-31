//
//  BusinessRow.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CFoundation
import RxDataSources

struct BusinessRow: Equatable {
    let title: String
    let subtitle: String
    
    let model: Business
    let type: BusinessType?
    
    init(model: Business) {
        self.model = model
        title = model.name
        
        type = model.type
        
        let distance = "\(Int(model.distance)) miles"
        if let price = model.price {
            subtitle = "\(price) * \(distance)"
        } else {
            subtitle = "\(distance)"
        }
    }
}
