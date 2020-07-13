//
//  MediaType.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import Foundation

enum MediaType: String, CaseIterable {
    case music
    case books
    case software
}

extension MediaType: CustomStringConvertible {
    var description: String {
        var result: String
        switch self {
        case .music: result = R.string.localizable.music()
        case .books: result = R.string.localizable.books()
        case .software: result = R.string.localizable.software()
        }
        return result
    }
}
