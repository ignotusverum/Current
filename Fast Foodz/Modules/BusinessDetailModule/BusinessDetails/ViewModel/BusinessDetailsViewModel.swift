//
//  BusinessDetailssViewModel.swift
//  BusinessDetailsModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

protocol BusinessDetailsViewModelProtocol {
    func transform(input: Observable<BusinessDetailsUIAction>) -> Observable<BusinessDetailsState>
    func transform(input: Observable<BusinessDetailsUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<BusinessDetailsState>
}

class BusinessDetailsViewModel: BusinessDetailsViewModelProtocol {
    let model: Business
    let events: PublishSubject<BusinessDetailsModuleEvents>
    
    init(model: Business,
         events: PublishSubject<BusinessDetailsModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<BusinessDetailsUIAction>) -> Observable<BusinessDetailsState> {
        return transform(input: input,
                         scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<BusinessDetailsUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<BusinessDetailsState> {
        Observable.feedbackLoop(initialState: BusinessDetailsState.details(BusinessDetailsSection(model: model)),
                                       scheduler: scheduler,
                                       reduce: { (state, action) -> BusinessDetailsState in
                                        switch action {
                                        case let .ui(action): return .reduce(state, action: action)
                                        case let .model(action): return .reduce(state, model: action)
                                        }
        }, feedback: { _ in input.map(BusinessDetailsActions.ui) },
           weakify(self,
                   default: .empty()) { (me: BusinessDetailsViewModel, state) in
                    .empty()
        })
            .sendSideEffects({ state in
                input.capture(case: BusinessDetailsUIAction.callNumber)
                    .map(BusinessDetailsModuleEvents.callBusiness)
            }, to: events.asObserver())
    }
}

