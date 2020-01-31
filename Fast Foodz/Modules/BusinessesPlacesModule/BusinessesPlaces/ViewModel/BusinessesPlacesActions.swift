//
//  BusinessesPlacesActions.swift
//  BusinessesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin
import CFoundation

enum BusinessesPlacesUIAction: EventProtocol {
    case annotationPressed(_ title: String)
}

enum BusinessesPlacesModelAction: EventProtocol {
    case loaded(_ sections: BusinessesPage)
    case error(_ error: Error)
}

enum BusinessesPlacesActions: EventProtocol {
    case ui(BusinessesPlacesUIAction)
    case model(BusinessesPlacesModelAction)
}

