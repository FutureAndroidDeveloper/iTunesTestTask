//
//  MediaObject.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import Foundation

protocol ITunesMedia {
    var trackName: String { get }
    var artistName: String { get }
    var artworkUrl: String? { get }
    var releaseDate: String { get }
    var imageData: Data? { get set }
}

struct MediaObject: ITunesMedia, Codable {
    var trackName: String
    var artistName: String
    var artworkUrl: String?
    var releaseDate: String
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case releaseDate
        case artworkUrl = "artworkUrl100"
    }
}
