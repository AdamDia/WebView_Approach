//
//  FileDownloaderTests.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import XCTest
@testable import WebView_Approach


class FileDownloaderTests: XCTestCase {
    var fileDownloader: FileDownloader!
    var mockNetworkService: MockNetworkService!
    var mockFileManagerService: MockFileManagerService!
    var mockUnzipService: MockUnzipService!
    var mockUserDefaults: MockUserDefaults!
    var mockFileURL: URL!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockFileManagerService = MockFileManagerService()
        mockUnzipService = MockUnzipService()
        mockUserDefaults = MockUserDefaults()
        fileDownloader = FileDownloader(networkService: mockNetworkService,
                                        fileManagerService: mockFileManagerService,
                                        unzipService: mockUnzipService, userDefaults: mockUserDefaults)
        mockFileURL = mockFileManagerService.createTemporaryURL()
    }
    
    override func tearDown() {
        fileDownloader = nil
        mockNetworkService = nil
        mockFileManagerService = nil
        mockUnzipService = nil
        mockFileURL = nil
        super.tearDown()
    }
    
    func testDownloadAndUnzipSuccessful() {
        mockNetworkService.result = .success(mockFileURL) // Simulate successful download
        mockUnzipService.result = .success(()) // Simulate successful unzip
        
        let expectation = self.expectation(description: "Download and Unzip Successful")
        fileDownloader.downloadFileIfNeeded { result in
            if case .success(let url) = result {
                XCTAssertNotNil(url, "Expected a valid URL")
            } else {
                XCTFail("Expected successful download and unzip")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDownloadFailureDueToNetworkIssues() {
        mockNetworkService.result = .failure(NetworkError.invalidResponse) // Simulate network failure
        
        let expectation = self.expectation(description: "Download Failure Due to Network")
        fileDownloader.downloadFileIfNeeded { result in
            if case .failure(let error) = result, case .downloadFailed = error {
                // Test passed
            } else {
                XCTFail("Expected download failure due to network issues")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDownloadSuccessButUnzipFails() {
        mockNetworkService.result = .success(mockFileURL) // Simulate successful download
        mockUnzipService.result = .failure(NetworkError.invalidLocalURL) // Simulate unzip failure
        
        let expectation = self.expectation(description: "Download Success but Unzip Fails")
        fileDownloader.downloadFileIfNeeded { result in
            if case .failure(let error) = result, case .unzipFailed = error {
                // Test passed
            } else {
                XCTFail("Expected unzip failure after successful download")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }    
}
