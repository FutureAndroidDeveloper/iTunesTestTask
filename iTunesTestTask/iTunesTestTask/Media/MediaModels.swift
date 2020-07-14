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
            }
        }
        struct Response {
            enum ResponseType {
                case mediaObj(media: [ITunesMedia])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case mediaViewModel(viewModel: [ITunesMedia])
            }
        }
    }
    
}
