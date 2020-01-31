//
//  BusinessesPlacesModel.swift
//  BusinessesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import RxSwift
import CFoundation

protocol BusinessesPlacesModelProtocol {
    func fetchBusinesses()-> Single<BusinessesPage>
}

class BusinessesPlacesModel: BusinessesPlacesModelProtocol {
    func fetchBusinesses()-> Single<BusinessesPage> {
        BusinessAdapter.fetch()
    }
}
