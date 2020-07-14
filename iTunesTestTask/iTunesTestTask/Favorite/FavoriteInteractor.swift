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
            
        case .remove(let media):
            let format = "trackName = %@ AND artistName = %@ AND releaseDate = %@"
            let predicate = NSPredicate(format: format,
                                        argumentArray: [media.trackName,
                                                        media.artistName,
                                                        media.releaseDate])
            // fetch removing object from Realm
            storage.fetch(RealmITunesMedia.self, predicate: predicate, sorted: nil) { result in
                guard let realmMedia = result.first else { return }
                // remove object from Realm
                try? storage.delete(object: realmMedia)
            }
        }
    }
    
}
