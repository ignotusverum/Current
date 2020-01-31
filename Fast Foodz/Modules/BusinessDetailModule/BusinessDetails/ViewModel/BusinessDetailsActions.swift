//
//  BusinessDetailsActions.swift
//  BusinessDetailModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

enum BusinessDetailsUIAction: EventProtocol {
    case callNumber(String)
}

enum BusinessDetailsModelAction: EventProtocol {}

enum BusinessDetailsActions: EventProtocol {
    case ui(BusinessDetailsUIAction)
    case model(BusinessDetailsModelAction)
}


