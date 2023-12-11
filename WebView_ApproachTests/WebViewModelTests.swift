//
//  WebViewModelTests.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

@testable import WebView_Approach
import XCTest
import RxSwift
import RxTest

class WebContentViewModelTests: XCTestCase {
    var viewModel: WebContentViewModel!
    var mockFileDownloader: MockFileDownloader!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        mockFileDownloader = MockFileDownloader()
        viewModel = WebContentViewModel(fileDownloader: mockFileDownloader)
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFileDownloader = nil
        disposeBag = nil
        super.tearDown()
    }
   
    func testLoadContent_Success() {
        let testFileURL = Bundle(for: type(of: self)).url(forResource: "testFile", withExtension: "html")!
        let expectedHTML = "<html>Test Content</html>\n" // Content of the test file
        
        mockFileDownloader.result = .success(testFileURL)
        
        let htmlContentExpectation = expectation(description: "htmlContent emitted")
        
        viewModel.htmlContent.subscribe(onNext: { webContent in
            XCTAssertEqual(webContent.originalPath, testFileURL)
            XCTAssertEqual(webContent.html, expectedHTML)
            htmlContentExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.loadContent()
        
        // Increase the timeout to allow more time for the asynchronous operation to complete
        wait(for: [htmlContentExpectation], timeout: 5.0)
    }
    
    
    func testInitialLoadingState() {
        let isLoadingExpectation = expectation(description: "Initial isLoading state")
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            XCTAssertFalse(isLoading)
            isLoadingExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [isLoadingExpectation], timeout: 1.0)
    }
    
    
    func testLoadContentFailure() {
        // Given
        let error = FileDownloaderError.downloadFailed(NetworkError.invalidResponse)
        mockFileDownloader.result = .failure(error)
        
        // When
        viewModel.loadContent()
        
        // Then
        let errorObserver = scheduler.createObserver(String.self)
        viewModel.errorMessage.bind(to: errorObserver).disposed(by: disposeBag)
        
        let loadingObserver = scheduler.createObserver(Bool.self)
        viewModel.isLoading.bind(to: loadingObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        let expectation = XCTestExpectation(description: "Wait for asynchronous operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(errorObserver.events.count, 1)
        XCTAssertEqual(loadingObserver.events, [.next(0, true), .next(0, false)])
    }
}

