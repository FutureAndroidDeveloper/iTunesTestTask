//
//  FavoriteModels.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

enum Favorite {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadFavorite
                case remove(media: ITunesMedia)
            }
        }
        struct Response {
            enum ResponseType {
                case favorite(media: [ITunesMedia])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case mediaViewModel(viewModel: [ITunesMedia])
            }
        }
    }
    
}
