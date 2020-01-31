//
//  LocationProtocol.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public protocol LocationProtocol {
    var address1: String { get }
    var address2: String? { get }
    var address3: String? { get }
    var city: String { get }
    var zipCode: String { get }
    var country: String { get }
    var state: String { get }
    var displayAddress: [String] { get }
}
