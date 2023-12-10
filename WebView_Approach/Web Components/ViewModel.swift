//
//  ViewModel.swift
//  WebView_Approach
//
//  Created by Adam Essam on 08/12/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct WebContent {
    let html: String
    let originalPath: URL
}

class WebContentViewModel {
    
    // Outputs
        var htmlContent: Observable<WebContent> {
           return htmlContentSubject.asObservable()
       }
       var errorMessage: Observable<String> {
           return errorMessageSubject.asObservable()
       }
    
        var isLoading: Observable<Bool> {
            return isLoadingSubject.asObservable()
        }
        
    private let fileDownloader: FileDownloading
    
    init(fileDownloader: FileDownloading) {
            self.fileDownloader = fileDownloader
        }
    
    // Private Subjects
        private let htmlContentSubject = PublishSubject<WebContent>()
        private let errorMessageSubject = PublishSubject<String>()
        private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
        private let disposeBag = DisposeBag()
    
   
    func loadContent() {
        isLoadingSubject.onNext(true)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fileDownloader.downloadFileIfNeeded { [weak self] indexPath in
                DispatchQueue.main.async {
                    guard let self = self, let indexPath = indexPath else {
                        self?.isLoadingSubject.onNext(false)
                        self?.errorMessageSubject.onNext("Failed to get file path")
                        return
                    }
                    
                    do {
                        let htmlContent = try String(contentsOf: indexPath, encoding: .utf8)
                        let webContent = WebContent(html: htmlContent, originalPath: indexPath)
                        self.htmlContentSubject.onNext(webContent)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isLoadingSubject.onNext(false)
                        }
                        
                    } catch {
                        self.errorMessageSubject.onNext("Error processing HTML content: \(error)")
                        self.isLoadingSubject.onNext(false)
                    }
                }
            }
        }
    }
}
