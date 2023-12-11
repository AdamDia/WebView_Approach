//
//  MockUnzipService.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation
@testable import WebView_Approach

class MockUnzipService: UnzipService {
    var result: Result<Void, Error>?

    func unzipFile(at: URL, to destination: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

enum MockUnzipError: Error {
    case failedUnzipping
}
