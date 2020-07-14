//
//  FavoriteInteractor.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

protocol FavoriteBusinessLogic {
    func makeRequest(request: Favorite.Model.Request.RequestType)
}

class FavoriteInteractor: FavoriteBusinessLogic {
    
    var presenter: FavoritePresentationLogic?
    private var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    func makeRequest(request: Favorite.Model.Request.RequestType) {
        switch request {
        case .loadFavorite:
            storage.fetch(RealmITunesMedia.self, predicate: nil, sorted: nil) { media in
                presenter?.presentData(response: .favorite(media: media))
            }
        }
    }
    
}
