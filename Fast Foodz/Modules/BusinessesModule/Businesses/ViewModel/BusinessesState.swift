//
//  BusinessesState.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

enum BusinessesState: CaseAccessible, Equatable {
    /// Ideally we would also want to introduce empty state, if there's no results
    case pages([BusinessRow])
    
    indirect case loading(whileInState: BusinessesState?)
    indirect case error(Error, whileInState: BusinessesState)
    
    static func reduce(_ state: BusinessesState,
                       action: BusinessesUIAction) -> BusinessesState {
        switch (state, action) {
        // Reload
        case let (.loading(aState), .reload):
            return .loading(whileInState: aState)
        case (.pages, .reload):
            return .loading(whileInState: state)
        // Not changing state
        default: return state
        }
    }
    
    static func reduce(_ state: BusinessesState,
                       model: BusinessesModelAction) -> BusinessesState {
        switch (state, model) {
        case (_, .loaded(let newDatasource)):
            
            /// Update when paging in place
            let pageToRows = newDatasource.items
                .map(BusinessRow.init)
            
            return .pages(pageToRows)
        case (_, let .error(error)):
            return .error(error, whileInState: state)
        }
    }
    
    static func == (lhs: BusinessesState,
                    rhs: BusinessesState) -> Bool {
        switch (lhs, rhs) {
        case let (.pages(lPages), .pages(rPages)): return lPages == rPages
        case let (.loading(lState), .loading(rState)): return lState == rState
        case let (.error(lError, lState), .error(rError, rState)):
            return lError.localizedDescription == rError.localizedDescription && lState == rState
        default: return false
        }
    }
}

