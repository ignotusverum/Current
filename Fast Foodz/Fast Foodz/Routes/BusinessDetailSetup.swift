//
//  BusinessDetailSetup.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/30/20.
//

import BusinessDetailModule
import MERLin
import Foundation
import CFoundation

typealias BusinessDetailEvent = BusinessDetailsModuleEvents

extension ModuleRoutingStep {
    static func businessDetails(_ details: Business) -> ModuleRoutingStep {
        let context = BusinessDetailModuleContext(details: details,
                                                  routingContext: "main")
        return ModuleRoutingStep(withMaker: context)
    }
}
