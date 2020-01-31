//
//  BusinessesPlacesState.swift
//  BusinessesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin
import CFoundation

enum BusinessesPlacesState: CaseAccessible, Equatable {
    case pages([BusinessPin])
    
    indirect case loading(whileInState: BusinessesPlacesState?)
    indirect case error(Error, whileInState: BusinessesPlacesState)
    
    static func reduce(_ state: BusinessesPlacesState,
                       action: BusinessesPlacesUIAction) -> BusinessesPlacesState {
        state
    }
    
    static func reduce(_ state: BusinessesPlacesState,
                       model: BusinessesPlacesModelAction) -> BusinessesPlacesState {
        switch (state, model) {
        case (_, .loaded(let newDatasource)):
            let pageToPins = newDatasource.items
                .map(BusinessPin.init)
            
            return .pages(pageToPins)
        case (_, let .error(error)):
            return .error(error, whileInState: state)
        }
    }
    
    static func == (lhs: BusinessesPlacesState,
                    rhs: BusinessesPlacesState) -> Bool {
        switch (lhs, rhs) {
        case let (.pages(lPages), .pages(rPages)): return lPages == rPages
        case let (.loading(lState), .loading(rState)): return lState == rState
        case let (.error(lError, lState), .error(rError, rState)):
            return lError.localizedDescription == rError.localizedDescription && lState == rState
        default: return false
        }
    }
}
