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
                case updateMedia
                case restoreLastTerm
                case save(media: ITunesMedia)
                case remove(media: ITunesMedia)
            }
        }
        struct Response {
            enum ResponseType {
                case mediaObj(media: [ITunesMedia], realmMedia: [ITunesMedia])
                case lastTerm(term: String?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case mediaViewModel(viewModel: [ITunesMedia])
                case lastTerm(text: String?)
            }
        }
    }
    
}
