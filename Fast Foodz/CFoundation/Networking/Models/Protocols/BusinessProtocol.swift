//
//  BusinessProtocol.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/30/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import Foundation

public protocol BusinessProtocol {
    var id: String { get }
    var alias: String { get }
    var name: String { get }
    var imageUrl: String { get }
    var isClosed: Bool { get }
    var url: String { get }
    var rating: Float { get }
    var price: String? { get }
    var phone: String { get }
    var displayPhone: String { get }
    var distance: Float { get }
    var transactions: [String] { get }
    var categories: [Category] { get }
    var location: Location { get }
    var coordinates: Coordinates { get }
}
