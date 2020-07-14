//
//  UserDefaultService.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import Foundation

protocol UserDefaultsWorking {
    var lastTerm: String? { get }
    func save(term: String)
}

class UserDefaultService: UserDefaultsWorking {
    private var defaults: UserDefaults
    
    static let termKey = "lastTerm"
    static let shared: UserDefaultsWorking = UserDefaultService()
    
    var lastTerm: String? {
        return defaults.string(forKey: UserDefaultService.termKey)
    }
    
    private init() {
        self.defaults = UserDefaults.standard
    }
    
    func save(term: String) {
        defaults.set(term, forKey: UserDefaultService.termKey)
    }
}
