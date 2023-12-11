//
//  MockUserDefaults.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation
@testable import WebView_Approach

class MockUserDefaults: UserDefaultsProtocol {
    var values = [String: Bool]()

    func bool(forKey defaultName: String) -> Bool {
        return values[defaultName] ?? false
    }

    func set(_ value: Bool, forKey defaultName: String) {
        values[defaultName] = value
    }

    func removeObject(forKey defaultName: String) {
        values.removeValue(forKey: defaultName)
    }
}
