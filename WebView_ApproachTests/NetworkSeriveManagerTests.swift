//
//  NetworkSeriveManagerTests.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 10/12/2023.
//

import XCTest
@testable import WebView_Approach

class NetworkServiceManagerTests: XCTestCase {
    var networkServiceManager: NetworkServiceManager!
    var urlSession: URLSession!
    var mockNetworkChecker: MockNetworkChecker!
    let downloadURL = "https://pstaticlanguage.blob.core.windows.net/consumer-kit/simplified-wrapper.zip"

    override func setUp() {
        super.setUp()
        MockURLProtocol.response = nil
        MockURLProtocol.error = nil
        MockURLProtocol.mockData = nil
            
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        mockNetworkChecker = MockNetworkChecker()
        networkServiceManager = NetworkServiceManager(session: urlSession, networkChecker: mockNetworkChecker)
    }

    override func tearDown() {
        networkServiceManager = nil
        mockNetworkChecker = nil
        urlSession = nil
        super.tearDown()
    }
    
    func testDownloadFileSuccess() {
        let expectation = self.expectation(description: "Download successful")
        let expectedURL = URL(string: downloadURL)!
        mockNetworkChecker.isNetworkAvailableResult = true // Simulate network availability

        // Configure MockURLProtocol for successful response
        MockURLProtocol.mockData = Data() // Empty data for testing
        MockURLProtocol.response = HTTPURLResponse(url: expectedURL, statusCode: 200, httpVersion: nil, headerFields: nil)

        networkServiceManager.downloadFile(from: expectedURL) { result in
            if case .success(let url) = result {
                XCTAssertNotNil(url)
            } else {
                XCTFail("Expected successful download")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }



    func testDownloadFileNetworkError() {
        let expectation = self.expectation(description: "Download fails with network error")
        let expectedURL = URL(string: downloadURL)!
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.error = error

        networkServiceManager.downloadFile(from: expectedURL) { result in
            if case .failure(let error as NSError) = result {
                XCTAssertEqual(error.code, NSURLErrorNotConnectedToInternet)
            } else {
                XCTFail("Expected network error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDownloadFileInvalidURL() {
        let expectation = self.expectation(description: "Download fails due to invalid URL")
        let invalidURL = URL(string: downloadURL)!
        MockURLProtocol.response = HTTPURLResponse(url: invalidURL, statusCode: 404, httpVersion: nil, headerFields: nil)

        networkServiceManager.downloadFile(from: invalidURL) { result in
            if case .failure(let error as NetworkError) = result {
                XCTAssertEqual(error, .invalidResponse)
            } else {
                XCTFail("Expected invalid response error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

   
    func testDownloadFileInvalidResponse() {
        let expectation = self.expectation(description: "Download fails with invalid response")
        let expectedURL = URL(string: downloadURL)!
        MockURLProtocol.response = HTTPURLResponse(url: expectedURL, statusCode: 404, httpVersion: nil, headerFields: nil) // 404 Not Found

        networkServiceManager.downloadFile(from: expectedURL) { result in
            if case .failure(let error as NetworkError) = result, error == .invalidResponse {
                // Test passed
            } else {
                XCTFail("Expected invalid response error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDownloadFileNoInternetConnection() {
        let expectation = self.expectation(description: "Download fails due to no internet connection")
        let expectedURL = URL(string: downloadURL)!
        mockNetworkChecker.isNetworkAvailableResult = false // Simulate no internet connection

        networkServiceManager.downloadFile(from: expectedURL) { result in
            switch result {
            case .failure(let error as NetworkError) where error == .noInternetConnection:
                // Test passed
                break
            default:
                XCTFail("Expected no internet connection error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

}
