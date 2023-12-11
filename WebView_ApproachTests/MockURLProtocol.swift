//
//  MockURLProtocol.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 10/12/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var response: URLResponse?
    static var error: Error?
    static var mockData: Data? = "dummy data".data(using: .utf8)
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
           if let response = MockURLProtocol.response {
               client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
               if let data = MockURLProtocol.mockData {
                   client?.urlProtocol(self, didLoad: data)
               }
               client?.urlProtocolDidFinishLoading(self)
           } else if let error = MockURLProtocol.error {
               client?.urlProtocol(self, didFailWithError: error)
           }
       }

    override func stopLoading() {
        //
    }
}
