//
//  BusinessesRoutingListener.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class BusinessesRoutingListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<BusinessesEvent>) -> Bool {
        
        events.capture(case: BusinessesEvent.businessIdSelected)
            .toRoutableObservable()
            .subscribe(onNext: { businessId in
                let detailsStep = PresentableRoutingStep(withStep: .businessDetails(),
                                                         presentationMode: .push(withCloseButton: .none),
                                                         animated: true)
                
                self.router.route(to: detailsStep)
                
            })
            .disposed(by: module.disposeBag)
            
        
        return true
    }
}

