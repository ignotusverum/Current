//
//  MainRoutingListenerAggregator.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class MainRoutingListenerAggregator: ModuleEventsListenersAggregator {
    var handledRoutingContext: [String]? = ["main"]
    
    let moduleListeners: [AnyModuleEventsListener]
    
    init(withRouter router: Router) {
        moduleListeners = [
            BusinessesRoutingListener(router),
            BusinessDetailRoutingListener(router),
            BusinessesPlacesRoutingListener(router),
        ]
    }
}
