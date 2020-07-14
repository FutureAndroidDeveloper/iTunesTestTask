//
//  ITunesStoreApi.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import Foundation

struct ITunesStoreResponse: Codable {
    let items: [MediaObject]
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}

