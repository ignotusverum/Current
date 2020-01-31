//
//  BusinessesPlacesStep.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin
import Foundation
import CFoundation
import BusinessesPlacesModule

typealias BusinessesPlacesEvent = BusinessesPlacesModuleEvents

extension ModuleRoutingStep {
    static func businessesPlaces() -> ModuleRoutingStep {
        let context = BusinessesPlacesModuleContext(routingContext: "main")
        return ModuleRoutingStep(withMaker: context)
    }
}
