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
        case .mediaObj(let media):
            print(media)
            viewController?.displayData(viewModel: .mediaViewModel(viewModel: media))
        }
    }
    
}
