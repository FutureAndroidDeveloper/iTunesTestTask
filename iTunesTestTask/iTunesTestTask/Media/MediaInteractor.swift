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
                self.presenter?.presentData(response: .mediaObj(media: mediaObjects))
            }
        }
    }
    
}
