//
//  AppDelegateRoutingEventsListener.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class AppDelegateRoutingEventsListener: EventsListener {
    var router: Router
    
    init(withRouter router: Router) {
        self.router = router
    }
    
    func listenEvents(from producer: AnyEventsProducer,
                      events: Observable<AppDelegateEvent>) -> Bool {
        producer.capture(event: AppDelegateEvent.willFinishLaunching)
            .toRoutableObservable()
            .map { $0.1 ?? [:] }
            .subscribe(onNext: { [weak self] launchOptions in
                guard let self = self,
                    let window = UIApplication.shared.windows.first else {
                    return
                }
                
                window.rootViewController = self.router.rootViewController(forLaunchOptions: launchOptions)
            })
            .disposed(by: producer.disposeBag)
        
        return true
    }
}
