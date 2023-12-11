//
//  UserDefaultsProtocol.swift
//  WebView_Approach
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation

protocol UserDefaultsProtocol {
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}
