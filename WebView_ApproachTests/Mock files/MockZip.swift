//
//  MockZip.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation

//class MockZip {
//    static var shouldSimulateSuccess = true
//
//    static func unzipFile(_ at: URL, destination: URL, overwrite: Bool, password: String?) throws {
//        if !shouldSimulateSuccess {
//            throw NSError(domain: "MockZipError", code: 0, userInfo: nil)
//        }
//
//        // Simulate successful unzipping by creating a dummy file at the destination
//        let dummyFilePath = destination.appendingPathComponent("dummy.txt")
//        FileManager.default.createFile(atPath: dummyFilePath.path, contents: nil, attributes: nil)
//    }
//}

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
