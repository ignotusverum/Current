//
//  BusinessesPlacesRoutingListener.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin

class BusinessesPlacesRoutingListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<BusinessesPlacesEvent>) -> Bool {
        
        events.capture(case: BusinessesPlacesEvent.annotationPressed)
            .toRoutableObservable()
            .subscribe(onNext: { _ in
                 UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            })
            .disposed(by: module.disposeBag)
            
        
        return true
    }
}

