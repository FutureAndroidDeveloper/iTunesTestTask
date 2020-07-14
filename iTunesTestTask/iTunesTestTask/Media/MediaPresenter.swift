//
//  MediaPresenter.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

protocol MediaPresentationLogic {
    func presentData(response: Media.Model.Response.ResponseType)
}

class MediaPresenter: MediaPresentationLogic {
    weak var viewController: MediaDisplayLogic?
    
    func presentData(response: Media.Model.Response.ResponseType) {
        switch response {
        case .mediaObj(let media, let realmMedia):
            
            let resultMedia = likeFavoriteMedia(networkMedia: media, realmMedia: realmMedia)
            viewController?.displayData(viewModel: .mediaViewModel(viewModel: resultMedia))
        }
    }
    
    
    private func likeFavoriteMedia(networkMedia: [ITunesMedia], realmMedia: [ITunesMedia]) -> [ITunesMedia] {
        var result = networkMedia
        for media in realmMedia {
            let firstIndex = result.firstIndex { netMedia -> Bool in
                return netMedia.artistName == media.artistName &&
                    netMedia.trackName == media.trackName &&
                    netMedia.releaseDate == media.releaseDate
            }
            if let index = firstIndex { result[index].isFavorite = media.isFavorite }
        }
        return result
    }
}
