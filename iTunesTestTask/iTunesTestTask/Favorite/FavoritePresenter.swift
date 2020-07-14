//
//  FavoritePresenter.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

protocol FavoritePresentationLogic {
    func presentData(response: Favorite.Model.Response.ResponseType)
}

class FavoritePresenter: FavoritePresentationLogic {
    weak var viewController: FavoriteDisplayLogic?
    
    func presentData(response: Favorite.Model.Response.ResponseType) {
        switch response {
        case .favorite(let mediaList):
            print("Saved MEdia:")
            mediaList.forEach { media in
                print(media)
                print()
            }
            
            viewController?.displayData(viewModel: .mediaViewModel(viewModel: mediaList))
        }
    }
    
}
