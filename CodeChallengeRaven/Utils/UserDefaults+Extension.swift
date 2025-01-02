//
//  UserDefaults+Extension.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import Foundation

extension UserDefaults {
    func set(_ data: Data, forKey key: String) {
        self.setValue(data, forKey: key)
    }

    func data(forKey key: String) -> Data? {
        return self.value(forKey: key) as? Data
    }
}
