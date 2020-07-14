//
//  MediaModels.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

enum Media {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadMedia(term: String, media: MediaType)
                case save(media: ITunesMedia)
                case remove(media: ITunesMedia)
            }
        }
        struct Response {
            enum ResponseType {
                case mediaObj(media: [ITunesMedia], realmMedia: [ITunesMedia])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case mediaViewModel(viewModel: [ITunesMedia])
            }
        }
    }
    
}
