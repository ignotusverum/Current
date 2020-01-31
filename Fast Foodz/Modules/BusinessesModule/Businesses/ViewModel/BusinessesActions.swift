//
//  BusinessesActions.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

enum BusinessesUIAction: EventProtocol {
    case reload
    case businessIdSelected(String)
}

enum BusinessesModelAction: EventProtocol {
    case loaded(_ sections: BusinessesPage)
    case error(_ error: Error)
}

enum BusinessesActions: EventProtocol {
    case ui(BusinessesUIAction)
    case model(BusinessesModelAction)
}

