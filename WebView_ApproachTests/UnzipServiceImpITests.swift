//
//  UnzipServiceImpITests.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import XCTest
@testable import WebView_Approach

class UnzipServiceImplTests: XCTestCase {
    var service: UnzipServiceImpl!
    
    override func setUp() {
        super.setUp()
        service = UnzipServiceImpl()
        service.zipHandler = MockZip.unzipFile
    }

    func testUnzipSuccess() {
        MockZip.shouldSimulateSuccess = true
        let expectation = self.expectation(description: "Unzip Success")

        service.unzipFile(at: URL(fileURLWithPath: "/path/to/source.zip"), to: URL(fileURLWithPath: "/path/to/destination")) { result in
            if case .success = result {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testUnzipFailure() {
        MockZip.shouldSimulateSuccess = false
        let expectation = self.expectation(description: "Unzip Failure")

        service.unzipFile(at: URL(fileURLWithPath: "/path/to/source.zip"), to: URL(fileURLWithPath: "/path/to/destination")) { result in
            if case .failure(let error as NSError) = result, error.domain == "MockZipError" {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

}
