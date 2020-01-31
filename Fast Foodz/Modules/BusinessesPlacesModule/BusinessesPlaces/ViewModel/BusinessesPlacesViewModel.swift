//
//  BusinessesPlacesViewModel.swift
//  BusinessesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin
import CFoundation

protocol BusinessesPlacesViewModelProtocol {
    func transform(input: Observable<BusinessesPlacesUIAction>) -> Observable<BusinessesPlacesState>
    func transform(input: Observable<BusinessesPlacesUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<BusinessesPlacesState>
}

class BusinessesPlacesViewModel: BusinessesPlacesViewModelProtocol {
    let model: BusinessesPlacesModelProtocol
    let events: PublishSubject<BusinessesPlacesModuleEvents>
    
    init(model: BusinessesPlacesModelProtocol,
         events: PublishSubject<BusinessesPlacesModuleEvents>) {
        self.model = model
        self.events = events
    }
    
    func transform(input: Observable<BusinessesPlacesUIAction>) -> Observable<BusinessesPlacesState> {
        return transform(input: input,
                         scheduler: MainScheduler.asyncInstance)
    }
    
    func transform(input: Observable<BusinessesPlacesUIAction>,
                   scheduler: ImmediateSchedulerType) -> Observable<BusinessesPlacesState> {
        let errors = PublishSubject<Error>()
        return Observable.feedbackLoop(initialState: BusinessesPlacesState.loading(whileInState: nil),
                                       scheduler: scheduler,
                                       reduce: { (state, action) -> BusinessesPlacesState in
                                        switch action {
                                        case let .ui(action): return .reduce(state, action: action)
                                        case let .model(action): return .reduce(state, model: action)
                                        }
        }, feedback: { _ in input.map(BusinessesPlacesActions.ui) },
           weakify(self,
                   default: .empty()) { (me: BusinessesPlacesViewModel, state) in
                    Observable.merge(state.capture(case: BusinessesPlacesState.loading).toVoid()
                        .compactFlatMapLatest { _ in
                            me.model
                                .fetchBusinesses()
                                .asObservable()
                                .catchError(sendTo: errors)
                                .map(BusinessesPlacesModelAction.loaded)
                        },
                                     errors.map(BusinessesPlacesModelAction.error))
                        .map(BusinessesPlacesActions.model)
        })
            .sendSideEffects({ state in
                input.capture(case: BusinessesPlacesUIAction.businessSelected)
                    .map(BusinessesPlacesModuleEvents.businessSelected)
            }, to: events.asObserver())
    }
}
