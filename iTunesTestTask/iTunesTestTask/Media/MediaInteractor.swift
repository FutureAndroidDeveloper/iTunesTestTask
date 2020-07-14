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
    private var latestMedia: [ITunesMedia]!
    
    init(networkService: Networking = NetworkManager(),
         storage: StorageContext = try! RealmStorageContext()) {
        self.networkService = networkService
        self.storage = storage
    }
    
    func makeRequest(request: Media.Model.Request.RequestType) {
        switch request {
        case .loadMedia(let term, let media):
            UserDefaultService.shared.save(term: term)      // save term
            networkService.getMedia(term: term, media: media) { [weak self] (response, error) in
                guard let self = self,
                    let mediaObjects = response?.items else { return }
                
                self.latestMedia = mediaObjects
                self.storage.fetch(RealmITunesMedia.self, predicate: nil, sorted: nil) { realmMedia in
                    self.presenter?.presentData(response: .mediaObj(media: mediaObjects,
                                                                    realmMedia: realmMedia))
                }
            }
            
        case .updateMedia:
            storage.fetch(RealmITunesMedia.self, predicate: nil, sorted: nil) { realmMedia in
                presenter?.presentData(response: .mediaObj(media: latestMedia,
                                                           realmMedia: realmMedia))
            }
            
        case .restoreLastTerm:
            // restore last term
            let term = UserDefaultService.shared.lastTerm
            presenter?.presentData(response: .lastTerm(term: term))
            
        case .save(let media):
            // create and save new object to Realm
            try? storage.create(RealmITunesMedia.self) { realmMedia in
                let grayImage = UIImage(data: media.imageData ?? Data())?.grayscale()
                realmMedia.artistName = media.artistName
                realmMedia.trackName = media.trackName
                realmMedia.releaseDate = media.releaseDate
                realmMedia.artworkUrl = media.artworkUrl
                realmMedia.imageData = grayImage?.pngData()
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
