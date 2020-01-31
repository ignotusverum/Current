//
//  BusinessesViewModel.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

protocol BusinessesViewModelProtocol {
    func transform(input: Observable<BusinessesUIAction>) -> Observable<BusinessesState>
    func transform(input: Observable<BusinessesUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<BusinessesState>
}

class BusinessesViewModel: BusinessesViewModelProtocol {
    let model: BusinessesModelProtocol
    let events: PublishSubject<BusinessesModuleEvents>
    
    init(model: BusinessesModelProtocol,
         events: PublishSubject<BusinessesModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<BusinessesUIAction>) -> Observable<BusinessesState> {
        return transform(input: input,
                         scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<BusinessesUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<BusinessesState> {
        let errors = PublishSubject<Error>()
        return Observable.feedbackLoop(initialState: BusinessesState.loading(whileInState: nil),
                                       scheduler: scheduler,
                                       reduce: { (state, action) -> BusinessesState in
                                        switch action {
                                        case let .ui(action): return .reduce(state, action: action)
                                        case let .model(action): return .reduce(state, model: action)
                                        }
        }, feedback: { _ in input.map(BusinessesActions.ui) },
           weakify(self,
                   default: .empty()) { (me: BusinessesViewModel, state) in
                    Observable.merge(state.capture(case: BusinessesState.loading).toVoid()
                        .compactFlatMapLatest { _ in
                            me.model
                                .fetchBusinesses()
                                .asObservable()
                                .catchError(sendTo: errors)
                                .map(BusinessesModelAction.loaded)
                        },
                                     errors.map(BusinessesModelAction.error))
                        .map(BusinessesActions.model)
        })
            .sendSideEffects({ state in
                input.capture(case: BusinessesUIAction.businessIdSelected)
                    .map(BusinessesModuleEvents.businessIdSelected)
            }, to: events.asObserver())
    }
}

