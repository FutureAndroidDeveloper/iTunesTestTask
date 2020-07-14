//
//  RealmTunesMedia.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/2/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RealmSwift

/*
 Dummy protocol for Entities
 */
public protocol Storable {
}
extension Object: Storable {
}

public class RealmITunesMedia: Object, ITunesMedia {
    var isFavorite: Bool = true
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var trackName: String = ""
    @objc dynamic var artistName: String = ""
    @objc dynamic var artworkUrl: String? = nil
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var imageData: Data? = nil
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}
