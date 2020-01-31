//
//  TopTabBarContainerStep.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/30/20.
//

import UIKit
import MERLin
import TopTabBarContainerModule

extension ModuleRoutingStep {
    static func topTabBarContainer(viewControllers: [UIViewController]) -> ModuleRoutingStep {
        let context = TopTabBarContainerContext(routingContext: "main",
                                                viewControllers: viewControllers)
        
        return ModuleRoutingStep(withMaker: context)
    }
}
