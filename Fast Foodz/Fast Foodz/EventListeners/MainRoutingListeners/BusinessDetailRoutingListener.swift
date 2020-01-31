//
//  BusinessDetailRoutingListener.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin

class BusinessDetailRoutingListener: ModuleEventsListener {
    var router: Router
    init(_ router: Router) {
        self.router = router
    }
    
    func listenEvents(from module: AnyEventsProducerModule,
                      events: Observable<BusinessDetailEvent>) -> Bool {
        
        events.capture(case: BusinessDetailEvent.callBusiness)
            .toRoutableObservable()
            .subscribe(onNext: { phone in
                guard let url = URL(string: "tel://\(phone)"),
                    UIApplication.shared.canOpenURL(url) else {
                        return
                }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: module.disposeBag)
        
        events.capture(case: BusinessDetailEvent.shareURL)
            .toRoutableObservable()
            .subscribe(onNext: { [weak module] urlPath in
                guard let url = URL(string: urlPath) else {
                        return
                }
                
                let activityViewController = UIActivityViewController(activityItems : [url],
                                                                      applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = module?.rootViewController?.view
                
                module?.rootViewController?.present(activityViewController,
                                                    animated: true,
                                                    completion: nil)
            })
            .disposed(by: module.disposeBag)
        
        
        return true
    }
}

