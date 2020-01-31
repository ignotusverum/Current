//
//  MatchesSetup.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import BusinessesModule
import MERLin
import Foundation

typealias BusinessesEvent = BusinessesModuleEvents

extension ModuleRoutingStep {
    static func businesses() -> ModuleRoutingStep {
        let context = BusinessesModuleContext(routingContext: "main")
        return ModuleRoutingStep(withMaker: context)
    }
}
