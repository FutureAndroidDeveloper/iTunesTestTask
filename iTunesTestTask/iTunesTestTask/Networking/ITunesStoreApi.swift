//
//  ITunesStoreApi.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation


enum ITunesStoreApi {
    case search(term: String, media: MediaType)
}

extension ITunesStoreApi: EndPointType {
    var basePath: String {
        return "https://itunes.apple.com/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: basePath) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .search: return "search"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .search(let term, let mediaType):
            return .requestWithParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["term": term,
                                                      "media": mediaType.apiMediaValue])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
