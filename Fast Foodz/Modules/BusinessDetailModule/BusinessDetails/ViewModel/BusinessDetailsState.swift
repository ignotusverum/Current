//
//  BusinessDetailsState.swift
//  BusinessDetailModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

enum BusinessDetailsState: CaseAccessible, Equatable {
    case details(BusinessDetailsSection)
    
    static func reduce(_ state: BusinessDetailsState,
                       action: BusinessDetailsUIAction) -> BusinessDetailsState {
        state
    }
    
    static func reduce(_ state: BusinessDetailsState,
                       model: BusinessDetailsModelAction) -> BusinessDetailsState {
        state
    }
}

