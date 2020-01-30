//
//  BusinessAPIConfigurable.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

public protocol BusinessAPIConfigurable where Self: MainAPIConfigurable {}

public extension BusinessAPIConfigurable {
    static var apiConfig: APIConfig { MainAPIConfig.businesses.config() }}

