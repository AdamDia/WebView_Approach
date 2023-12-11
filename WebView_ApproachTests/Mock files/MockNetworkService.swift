//
//  MockNetworkService.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation
@testable import WebView_Approach

class MockNetworkService: NetworkService {
    var result: Result<URL, Error>?

    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
