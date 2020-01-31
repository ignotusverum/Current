//
//  BusinessDetailSetup.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/30/20.
//

import BusinessDetailModule
import MERLin
import Foundation

typealias BusinessDetailEvent = BusinessDetailModuleEvents

extension ModuleRoutingStep {
    static func businessDetails() -> ModuleRoutingStep {
        let context = BusinessDetailModuleContext(routingContext: "main")
        return ModuleRoutingStep(withMaker: context)
    }
}
