//
//  MatchesAdapter+Config.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import CFoundation

extension BusinessAdapter:
    MainAPIConfigurable,
    NetworkingConfigurable,
    BusinessAPIConfigurable {
    public static func configurator() {
        BusinessAdapter(config: AdapterConfig(base: baseURL,
                                              name: apiConfig.path))
    }
}

