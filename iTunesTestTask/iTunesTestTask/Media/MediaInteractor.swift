//
//  MediaInteractor.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

protocol MediaBusinessLogic {
    func makeRequest(request: Media.Model.Request.RequestType)
}

class MediaInteractor: MediaBusinessLogic {
    
    var presenter: MediaPresentationLogic?
    private var networkService: Networking!
    private var storage: StorageContext!
    
    init(networkService: Networking = NetworkManager(),
         storage: StorageContext = try! RealmStorageContext()) {
        self.networkService = networkService
        self.storage = storage
    }
    
    func makeRequest(request: Media.Model.Request.RequestType) {
        switch request {
        case .loadMedia(let term, let media):
            networkService.getMedia(term: term, media: media) { [weak self] (response, error) in
                guard let self = self,
                    let mediaObjects = response?.items else { return }
                
                self.storage.fetch(RealmITunesMedia.self, predicate: nil, sorted: nil) { realmMedia in
                    self.presenter?.presentData(response: .mediaObj(media: mediaObjects,
                                                                    realmMedia: realmMedia))
                }
            }
            
        case .save(let media):
            // create and save new object to Realm
            try? storage.create(RealmITunesMedia.self) { realmMedia in
                realmMedia.artistName = media.artistName
                realmMedia.trackName = media.trackName
                realmMedia.releaseDate = media.releaseDate
                realmMedia.artworkUrl = media.artworkUrl
                realmMedia.imageData = media.imageData
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
