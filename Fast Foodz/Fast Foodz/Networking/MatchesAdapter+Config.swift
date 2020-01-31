//
//  BusinessAdapter+Config.swift
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
                                              name: apiConfig.path,
                                              headers: ["Authorization": "Bearer EM4gJp1gsCjaU0JF0dZY6EI0c3JfcBV51ZzJzfGjX3gqs0D9VN0VGD5-mmCE4Gnasz-AzR8oiZNAcsZ4dHo87m0LEMbbzUsa3LdYpHI24RFIDhxKjHR6A8X4GaksXnYx"]))
    }
}

