//
//  MockZip.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation

class MockZip {
    static var shouldSimulateSuccess = true

    static func unzipFile(_ at: URL, destination: URL, overwrite: Bool, password: String?, progress: ((Double) -> Void)?, completion: ((URL) -> Void)?) throws {
        if !shouldSimulateSuccess {
            throw NSError(domain: "MockZipError", code: 0, userInfo: nil)
        }

        // Simulate successful unzipping
        // Optionally, you can call the progress and completion callbacks here
        progress?(1.0)
        completion?(destination)
    }
}
