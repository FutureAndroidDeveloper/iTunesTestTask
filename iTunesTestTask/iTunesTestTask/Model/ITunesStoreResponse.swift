//
//  ITunesStoreApi.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import Foundation

protocol ITunesMedia {
    var trackName: String { get }
    var artistName: String { get }
    var artworkUrl: URL? { get }
    var releaseDate: String { get }
}

struct ITunesStoreResponse: Codable {
    let items: [MediaObject]
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}

struct MediaObject: ITunesMedia, Codable {
    var trackName: String
    var artistName: String
    var artworkUrl: URL?
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case releaseDate
        case artworkUrl = "artworkUrl100"
    }
}
