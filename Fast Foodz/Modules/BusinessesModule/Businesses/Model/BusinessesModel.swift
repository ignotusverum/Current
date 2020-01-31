//
//  BusinessesModel.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import RxSwift
import CFoundation

protocol BusinessesModelProtocol {
    func fetchBusinesses()-> Single<BusinessesPage>
}

class BusinessesModel: BusinessesModelProtocol {
    func fetchBusinesses()-> Single<BusinessesPage> {
        BusinessAdapter.fetch()
    }
}

