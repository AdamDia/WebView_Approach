//
//  MockNetworkChecker.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 10/12/2023.
//

@testable import WebView_Approach

class MockNetworkChecker: NetworkChecking {
    var isNetworkAvailableResult: Bool = true

    func isNetworkAvailable(completion: @escaping (Bool) -> Void) {
        completion(isNetworkAvailableResult)
    }
}
