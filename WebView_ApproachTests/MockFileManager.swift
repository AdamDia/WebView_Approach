//
//  MockFileManager.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation
@testable import WebView_Approach

class MockFileManagerService: FileManagerService {
    var error: Error?

    func moveItem(at: URL, to: URL) throws {
        if let error = error {
            throw error
        }
    }
    
    func createTemporaryURL() -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString // Unique file name
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        // Create a temporary file
        FileManager.default.createFile(atPath: fileURL.path, contents: Data(), attributes: nil)
        return fileURL
    }

}
